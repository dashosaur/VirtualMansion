//  File.swift
//  
//
//  Created by Dash on 12/31/20.
//

import Sword

enum Award: UInt64 {
    case gamer = 794303640277483561
    case socialButterfly = 794304325047681034
    
    var snowflake: Snowflake {
        Snowflake(rawValue: rawValue)
    }
}

extension Award {
    var inlineName: String {
        switch self {
        case .gamer:
            return "gamer"
        case .socialButterfly:
            return "social butterfly"
        }
    }
    
    private static let genericAnnouncementOptions: [String] = [
        "<user> just earned the <award> award. Congratulations!",
        "<user> you're amazing! You now have the <award> award.",
        "WOWOWOW check out <user> who is officially a <award>!!",
    ]
    
    var randomAnnouncementFormat: String {
        // TODO: custom messages per role
        switch self {
//        case .gamer:
//
        default:
            return Self.genericAnnouncementOptions.randomElement()!
        }
    }
}
