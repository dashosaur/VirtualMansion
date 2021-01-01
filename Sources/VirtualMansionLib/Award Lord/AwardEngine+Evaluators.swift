//
//  AwardEngine+Evaluators.swift
//  
//
//  Created by Allan Shortlidge on 12/31/20.
//

import Foundation

extension AwardEngine {
    mutating func setUpDefaultEvaluators() {
        // 🕹 Gamer: Any visited channel is a gaming channel.
        addEvaluator { userState in
            guard !userState.existingAwards.contains(.gamer) else { return nil }
            
            return KnownChannel.gamerChannels.isDisjoint(with: userState.visitedChannels) ? nil : .gamer
        }
        
        // 🔎 Sleuth: All secret channels have been visited.
        addEvaluator { userState in
            guard !userState.existingAwards.contains(.sleuth) else { return nil }
            
            return KnownChannel.secretChannels.isSubset(of: userState.visitedChannels) ? .sleuth : nil
        }
    }
}
