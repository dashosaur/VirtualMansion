//  File.swift
//  
//
//  Created by Dash on 12/31/20.
//

import Sword

enum Award: UInt64 {
    case gamer = 794303640277483561
    case narcissisticNarwhal = 794372289462272000
    case sleuth = 794358182846791731
    case socialButterfly = 794304325047681034
    
    var snowflake: Snowflake {
        Snowflake(rawValue: rawValue)
    }
}

extension Award: CaseIterable {
    var inlineName: String {
        switch self {
        case .gamer:                return "gamer"
        case .narcissisticNarwhal:  return "narcissistic narwhal"
        case .sleuth:               return "sleuth"
        case .socialButterfly:      return "social butterfly"
        }
    }
    
    var emojiName: String {
        switch self {
        case .gamer:                return "🕹"
        case .narcissisticNarwhal:  return "🦄"
        case .sleuth:               return "🔎"
        case .socialButterfly:      return "🦋"
        }
    }
    
    var fullName: String { "\(emojiName) \(inlineName)" }
    
    private static let genericAnnouncementOptions: [String] = [
        "<user> just earned the <award> award. Congratulations!",
        "<user> you're amazing! You now have the <award> award.",
        "WOWOWOW check out <user> who is officially a <award>!!",
    ]
    
    var randomAnnouncementFormat: String {
        var announcements = Self.genericAnnouncementOptions
        switch self {
        case .gamer:
            announcements = [
                "<user> is quite a player 🕹",
                "<user>, you're a <award> now! I hope you win!",
            ]
        case .narcissisticNarwhal:
            announcements = [
                "<user>, you look very pretty tonight. You've been awarded the Narcissistic Narwhal role for looking in the hallway mirror 10 times."
            ]
        case .sleuth:
            announcements = [
                "Good detective work 🔎, <user>!"
            ]
        
        default:
            break
        }
        
        return announcements.randomElement()!
    }
}
