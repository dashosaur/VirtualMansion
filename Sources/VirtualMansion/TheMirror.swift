//  TheMirror.swift
//  
//
//  Created by Dash on 12/31/20.
//

import Foundation
import Sword
import os

struct TheMirror: Bot {
    private let bot: Sword
    
    init(token: String) {
        bot = Sword(token: token)
    }
    
    func run() {
        bot.editStatus(to: "online", playing: "with your heart")
        
        bot.on(.voiceChannelJoin) { data in
            guard let (snowflake, voiceState) = data as? (Snowflake, VoiceState) else {
                log(level: .error, "Invalid data of type: \(type(of: data))")
                return
            }
            log(level: .debug, "Voice channel joined\n  Snowflake: \(snowflake)\n  Voice state: \(String(describing: voiceState))")
            bot.getUser(snowflake) { (user, error) in
                guard let user = user else {
                    log(level: .error, "Invalid user: \(String(describing: error))")
                    return
                }
                
                switch voiceState.channelId.knownChannel {
                case .hallwayMirror:
                    complimentUser(user)
                case .hallwayMirrorReverse:
                    complimentUser(user, reversed: true)
                case .none:
                    log("Unknown channel: \(voiceState.channelId.rawValue)")
                }
            }
        }
        
        bot.connect()
    }
    
    func complimentUser(_ user: User, reversed: Bool = false) {
        log("Complimenting \(user.username ?? String(user.id.rawValue))")
        
        let compliment = String.compliments.randomElement()!
        bot.getDM(for: user.id) { (dm, error) in
            guard let dm = dm else {
                log(level: .error, "Invalid DM: \(String(describing: error))")
                return
            }
            bot.send(reversed ? String(compliment.reversed()) : compliment, to: dm.id)
        }
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
