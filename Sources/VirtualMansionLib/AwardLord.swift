//
//  AwardLord.swift
//  
//
//  Created by Allan Shortlidge on 12/31/20.
//

import Foundation
import Sword

public struct AwardLord: Bot {
    private let bot: Sword
    
    public init(token: String) {
        bot = Sword(token: token)
    }
    
    public func run() {
        bot.editStatus(to: "online", playing: "judging your achievements")

        bot.on(.voiceChannelJoin) { data in
            guard let (snowflake, voiceState) = data as? (Snowflake, VoiceState) else {
                print("invalid data type: \(type(of: data))")
                return
            }
            print("!snowflake: \(snowflake)")
            print("!voice state: \(voiceState)")
        }

        bot.on(.messageCreate) { data in
            let msg = data as! Message
            
            if msg.content == "!ping" {
                msg.reply(with: "Pong (Award Lord)!")
            }
        }
        
        bot.connect()
    }

}
