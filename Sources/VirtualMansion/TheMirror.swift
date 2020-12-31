//  TheMirror.swift
//  
//
//  Created by Dash on 12/31/20.
//

import Foundation
import Sword

struct TheMirror: Bot {
    func run(token: String) {
        let bot = Sword(token: token)
        
        bot.editStatus(to: "online", playing: "with your heart")
        
        bot.on(.voiceChannelJoin) { data in
            guard let (snowflake, voiceState) = data as? (Snowflake, VoiceState) else {
                print("invalid data type: \(type(of: data))")
                return
            }
            print("!snowflake: \(snowflake)")
            print("!voice state: \(voiceState)")
        }
        
        bot.on(.voiceChannelJoin) { data in
            guard let (snowflake, voiceState) = data as? (Snowflake, VoiceState) else {
                print("invalid data type: \(type(of: data))")
                return
            }
            print("snowflake: \(snowflake)")
            print("voice state: \(voiceState)")
            if voiceState.channelId.rawValue == 793709576112570429 {
                print("entered mirror")
                bot.getDM(for: snowflake) { (dm, error) in
                    guard let dm = dm else {
                        print("error: \(error.debugDescription)")
                        return
                    }
                    bot.send(String.compliments.randomElement() ?? "", to: dm.id)
                }
            } else if voiceState.channelId.rawValue == 794080225645953055 {
                print("entered reverse mirror")
                bot.getDM(for: snowflake) { (dm, error) in
                    guard let dm = dm else {
                        print("error: \(error.debugDescription)")
                        return
                    }
                    bot.send(String(String.compliments.randomElement()!.reversed()), to: dm.id)
                }
            } else {
                print("entered \(voiceState.channelId.rawValue)")
            }
        }
        
        bot.on(.messageCreate) { data in
            
            let msg = data as! Message
            
            if msg.content == "!ping" {
                msg.reply(with: "Pong (The Mirror)!")
            }
        }
        
        bot.connect()
    }
}

fileprivate extension String {
    static let compliments = [
        "You are so pretty",
        "You're gorgeous—and that's the least interesting thing about you, too.",
        "You look great today.",
        "Your eyes are breathtaking.",
        "How is it that you always look so great, even if you're in ratty pajamas?",
        "That color is perfect on you.",
        "You smell really good.",
        "You may dance like no one's watching, but everyone's watching because you're mesmerizing.",
        "You have cute elbows. For real.",
        "Your bellybutton is kind of adorable.",
        "Your hair looks stunning.",
        "Your voice is magnificent.",
        "Your name suits you to a T.",
        "You're irresistible when you blush.",
        "Has anyone ever told you that you have great posture?",
        "Your smile is contagious.",
        "Whoa, your outfit is so amazing!",
        "I love your sense of style.",
        "I'm so into the way you did your hair! Could you teach me sometime?",
        "Seriously, your skin has the best glow.",
        "You are astoundingly gorgeous when you wake up in the morning.",
        "Your eyes are so warm and welcoming.",
        "You look like you spend all of your time in the gym!",
        "You're not wearing any makeup? Wow, you are flawless.",
        "You light up a room when you walk in, and people definitely notice.",
        "Your hairstyle frames your face perfectly.",
        "Your face brightens up when you laugh and it spreads joy to those around you.",
        "Your style is impeccable.",
        "That color is perfect on you.",
        "You make that outfit look amazing, not many people could pull that off like you do!",
        "You have a spring in your step today that is brightening up my day.",
        "You look very happy and your energy is contagious.",
        "You weren’t kidding when you said you were hitting the gym!",
        "I always get lost in your eyes.",
        "Your inside is even more beautiful than your outside.",
        "You exude confidence which really makes you beautiful.",
        "You are radiant.",
        "There’s a beautiful softness behind your eyes.",
        "Has anyone ever told you that you have outstanding posture?",
        "You are glowing.",
        "You always make ordinary things look great.",
        "Your smile is infectious.",
    ]
}
