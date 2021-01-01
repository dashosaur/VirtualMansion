//  TheMirror.swift
//  
//
//  Created by Dash on 12/31/20.
//

import Foundation
import Sword
import os

public struct TheMirror: Bot {
    private let sword: Sword
    private let guild: Guild
    
    public var botName: String { "The Mirror" }
    
    public init(sword: Sword, guild: Guild, database: Database) {
        self.sword = sword
        self.guild = guild
    }
    
    public func run() {
        sword.editStatus(to: "online", playing: "with your heart")
        
        sword.onVoiceChannelJoin { (member, voiceState) in
            let knownChannel = voiceState.channelId.knownChannel
            switch knownChannel {
            case .hallwayMirror:
                complimentUser(member.user)
            case .hallwayMirrorReverse:
                complimentUser(member.user, reversed: true)
            case .none:
                log(level: .error, "Unknown channel: \(voiceState.channelId.rawValue)")
            default:
                log(level: .debug, "Irrelevant channel: \(knownChannel!)")
            }
        }
    }
    
    func complimentUser(_ user: User, reversed: Bool = false) {
        log("Complimenting \(user.debugIdenitifier)\(reversed ? " in reverse" : "")")
        
        let compliment = String.compliments.randomElement()!
        sword.getDM(for: user.id) { (dm, error) in
            guard let dm = dm else {
                log(level: .error, "Invalid DM: \(String(describing: error))")
                return
            }
            sword.send(reversed ? String(compliment.reversed()) : compliment, to: dm.id)
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
        "Look at how fabulous you are!",
        "Look at all that drippy swag!",
        "Let me dust your shoulder off 🌬️",
        "one word for you.... Savage! ;cb",
        "Damn you're fine!",
        "Are you French? Because Eiffel for you.",
        "Do you like raisins? How do you feel about a date?",
        "There is something wrong with my cell phone. It doesn't have your number in it.",
        "If I could rearrange the alphabet, I’d put ‘U’ and ‘I’ together.",
        "Aside from being sexy, what do you do for a living?",
        "I must be a snowflake, because I've fallen for you.",
        "Are you from Tennessee? Because you're the only 10 I see!",
        "If you were a Transformer… you’d be Optimus Fine.",
        "Are you a parking ticket? Because you’ve got FINE written all over you.",
        "I must be in a museum, because you truly are a work of art.",
        "Hey, how you doin?!",
        "I'm no photographer, but I can picture us together.",
        " Know what I'm made of? ..... Lover material.",
        "Are you related to Jean-Claude Van Damme? Because Damme you’re sexy!",
        "Did your license get suspended for driving all these folks crazy?",
        "I’m learning about important dates in history. Wanna be one of them?",
        "I must be signing my rights away... cause damn, you’re some fine print!",
        "Did you just come out of the oven? Because you’re hot.",
        "It’s a good thing I have my library card because I am totally checking you out.",
        "I was blinded by your beauty; I’m going to need your name and phone number for insurance purposes.",
        "I was wondering if you had an extra heart. Because mine was just stolen.",
        "Is your name Google? Because you have everything I’ve been searching for.",
        "Are you a bank loan? Because you got my interest.",
        "Are you a time traveler? Cause I see you in my future!",
        "Can I follow you where you’re going right now? Because my parents always told me to follow my dreams.",
        "Life without you is like a broken pencil… pointless.",
        "Something’s wrong with my eyes because I can’t take them off you.",
    ]
}
