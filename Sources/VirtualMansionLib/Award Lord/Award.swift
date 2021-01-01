//  File.swift
//  
//
//  Created by Dash on 12/31/20.
//

import Sword

enum Award: UInt64 {
    case achievementUnlocked = 794411292391374850
    case cannonball = 794411077621645334
    case gamer = 794303640277483561
    case goddam = 794412021587247144
    case gumshoe = 794410665564700692
    case narcissisticNarwhal = 794372289462272000
    case privateEye = 794410868809007104
    case saturdayNightFever = 794411691525406732
    case sleuth = 794358182846791731
    case socialButterfly = 794304325047681034
    case socialCaterpillar = 794409859897622529
    case socialChrysalis = 794410224480026624
    case sufferingFromQuiplash = 794412560581263370
    
    var snowflake: Snowflake {
        Snowflake(rawValue: rawValue)
    }
}

extension Award: CaseIterable {
    var inlineName: String {
        switch self {
        case .achievementUnlocked:      return "achievement unlocked"
        case .cannonball:               return "cannonball"
        case .gamer:                    return "gamer"
        case .goddam:                   return "I said goddam!"
        case .gumshoe:                  return "gumshoe"
        case .narcissisticNarwhal:      return "narcissistic narwhal"
        case .privateEye:               return "private eye"
        case .saturdayNightFever:       return "saturday night fever"
        case .sleuth:                   return "sleuth"
        case .socialButterfly:          return "social butterfly"
        case .socialCaterpillar:        return "social caterpillar"
        case .socialChrysalis:          return "social chrysalis"
        case .sufferingFromQuiplash:    return "suffering from quiplash"
        }
    }
    
    var emojiName: String {
        switch self {
        case .achievementUnlocked:      return "🏅"
        case .cannonball:               return "💦"
        case .gamer:                    return "🕹"
        case .goddam:                   return "💄"
        case .gumshoe:                  return "🕵️"
        case .narcissisticNarwhal:      return "🦄"
        case .privateEye:               return "🕵🏼‍♂️"
        case .saturdayNightFever:       return "💃"
        case .sleuth:                   return "🔎"
        case .socialButterfly:          return "🦋"
        case .socialCaterpillar:        return "🐛"
        case .socialChrysalis:          return "🧬"
        case .sufferingFromQuiplash:    return "🤣"
        }
    }
    
    var fullName: String { "\(emojiName) \(inlineName)" }
    
    private static let genericAnnouncementOptions: [String] = [
        "<user> just earned the <award> award. Congratulations!",
        "<user> you're amazing! You now have the <award> award.",
        "WOWOWOW check out <user> who is officially a <award>!!",
        "...and the <award> award goes to <user>!",
        "Stop the party. <user> has just earned the <award> award.",
    ]
    
    var randomAnnouncementFormat: String {
        let announcements: [String]
        switch self {
        case .gamer:
            announcements = [
                "<user> is quite a player 🕹",
                "<user>, you're a <award> now! I hope you win!",
            ]
        case .narcissisticNarwhal:
            announcements = [
                "<user>, looking good tonight. You've earned the <award> award for how many times you've glanced in the hallway mirror.",
                "Who's the prettiest <award> of them all? <user>, of course. Congrats on your new award.",
            ]
        case .sleuth:
            announcements = [
                "Good detective work 🔎, <user>!",
                "<user> is getting clever with the sleuthing tonight. Excellent work.",
            ]
        case .cannonball:
            announcements = Self.genericAnnouncementOptions + [
                "SPLASH! <user> just earned the <award> award!",
            ]
        default:
            announcements = Self.genericAnnouncementOptions
        }
        
        return announcements.randomElement()!
    }
}
