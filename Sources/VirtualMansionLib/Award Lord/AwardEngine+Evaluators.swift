//
//  AwardEngine+Evaluators.swift
//  
//
//  Created by Allan Shortlidge on 12/31/20.
//

import Foundation

extension AwardEngine {
    mutating func setUpDefaultEvaluators() {
        // 🕹 Gamer: Visit any gaming channel.
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
        
        // 🔎 Sleuth: Visit all secret channels.
        addEvaluator { userState in
            guard !userState.existingAwards.contains(.sleuth) else { return nil }
            return KnownChannel.secretChannels.isSubset(of: userState.visitedChannels) ? .sleuth : nil
        }
        
        // 🦄 Narcissistic Narwhal: Visit the mirror 10 times.
        addEvaluator { userState in
            guard !userState.existingAwards.contains(.narcissisticNarwhal) else { return nil }
            return userState.channelVisits[.hallwayMirror, default: 0] >= 10 ? .narcissisticNarwhal : nil
        }
        
        // 💄 I Said Goddamn!: Visit the powder room 10 times.
        addEvaluator { userState in
            guard !userState.existingAwards.contains(.goddam) else { return nil }
            return userState.channelVisits[.powderRoom, default: 0] >= 10 ? .goddam : nil
        }
        
        // 🕵️ Cannonball: Enter the hot tub.
        addEvaluator { userState in
            guard !userState.existingAwards.contains(.cannonball) else { return nil }
            return userState.channelVisits[.hotTub, default: 0] >= 1 ? .cannonball : nil
        }
        
        // 💃 Saturday Night Fever: Visit the Discotheque 5 times.
        addEvaluator { userState in
            guard !userState.existingAwards.contains(.saturdayNightFever) else { return nil }
            return userState.channelVisits[.discotheque, default: 0] >= 5 ? .saturdayNightFever : nil
        }
        
        // 🐛 Social Caterpillar: Visit 5 party rooms.
        addEvaluator { userState in
            guard !userState.existingAwards.contains(.socialCaterpillar) else { return nil }
            return KnownChannel.socialChannels.intersection(userState.visitedChannels).count >= 5 ? .socialCaterpillar : nil
        }
        
        // 🐛👑 Social Chrysalis: Visit 10 party rooms.
        addEvaluator { userState in
            guard !userState.existingAwards.contains(.socialChrysalis) else { return nil }
            return KnownChannel.socialChannels.intersection(userState.visitedChannels).count >= 10 ? .socialChrysalis : nil
        }
        
        // 🦋 Social Butterfly: Visit all social rooms.
        addEvaluator { userState in
            guard !userState.existingAwards.contains(.socialButterfly) else { return nil }
            return KnownChannel.socialChannels.isSubset(of: userState.visitedChannels) ? .socialButterfly : nil
        }
        
        // TODO:
//        Achievement Unlocked    🏅    Get 5 awards
//        Suffering from Quiplash    🤣    Visit the Jackbox Table (3x/20m)
    }
}
