//
//  File.swift
//  
//
//  Created by Allan Shortlidge on 12/31/20.
//

import Foundation
import Sword

struct AwardLord: Bot {
    private let bot: Sword
    
    init(token: String) {
        bot = Sword(token: token)
    }
    
    func run() {
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
