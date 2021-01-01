//
//  AwardEngine.swift
//  
//
//  Created by Allan Shortlidge on 12/31/20.
//

import Foundation

struct AwardEngine {
    struct UserState {
        let channelVisits: [KnownChannel: Int]
        let existingAwards: Set<Award>
        
        let visitedChannels: Set<KnownChannel>
        
        init(channelVisits: [KnownChannel: Int], existingAwards: Set<Award>) {
            self.channelVisits = channelVisits
            self.existingAwards = existingAwards
            self.visitedChannels = Set(channelVisits.compactMap { visit in (visit.value > 0) ? visit.key : nil })
        }
    }
    
    var evaluators: [(UserState) -> Award?] = []
    
    mutating func addEvaluator(_ evaluator: @escaping (UserState) -> Award?) {
        evaluators.append(evaluator)
    }
    
    /// Returns new awards that should be awarded given the user state.
    func evaluateAwards(userState: UserState) -> [Award] {
        return evaluators.compactMap { evaluator in
            evaluator(userState)
        }
    }
}
