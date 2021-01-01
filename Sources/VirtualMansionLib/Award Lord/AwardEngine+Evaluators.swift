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
        
        // 🕵️ Gumshoe: Visit a secret room.
        addEvaluator { userState in
            guard !userState.existingAwards.contains(.gumshoe) else { return nil }
            return KnownChannel.secretChannels.intersection(userState.visitedChannels).count >= 1 ? .gumshoe : nil
        }
        
        // 🕵🏼‍♂️ Private Eye: Visit 3 secret rooms.
        addEvaluator { userState in
            guard !userState.existingAwards.contains(.privateEye) else { return nil }
            return KnownChannel.secretChannels.intersection(userState.visitedChannels).count >= 3 ? .privateEye : nil
        }
        
        // 🔎 Sleuth: All secret channels have been visited.
        addEvaluator { userState in
            guard !userState.existingAwards.contains(.sleuth) else { return nil }
            return KnownChannel.secretChannels.isSubset(of: userState.visitedChannels) ? .sleuth : nil
        }
        
        // 🦄 Narcissistic Narwhal: Visited the mirror 10 times.
        addEvaluator { userState in
            guard !userState.existingAwards.contains(.narcissisticNarwhal) else { return nil }
            return userState.channelVisits[.hallwayMirror, default: 0] >= 10 ? .narcissisticNarwhal : nil
        }
        
        // TODO:
//        Social Butterfly    🦋    Visit all party VCs (excluding tech-support)
//        Social Caterpillar    🐛    Visit 5 party rooms
//        Social Chrysalis    🐛👑    Visit 10 party rooms
//        Hot Tub Tardis    🧖    Be one of 20 simultaneous people in the Hot Tub
//        Cannonball!    💦    Enter the hot tub
//        Achievement Unlocked    🏅    Get 5 awards
//        I Said Goddamn!    💄    Visit the powder room 10 times
//        Saturday Night Fever    💃    Visit the Discotheque 5 times
//        Suffering from Quiplash    🤣    Visit the Jackbox Table (3x/20m)
    }
}
