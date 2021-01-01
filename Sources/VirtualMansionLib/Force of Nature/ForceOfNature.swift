//  ForceOfNature.swift
//  
//
//  Created by Dash on 12/31/20.
//

import Sword

public final class ForceOfNature: Bot {
    private let sword: Sword
    private let guild: Guild
    
    public var botName: String { "Force of Nature" }
    
    public init(sword: Sword, guild: Guild, database: Database) {
        self.sword = sword
        self.guild = guild
    }
    
    private var roofVoiceStatesByUserID = [Snowflake : VoiceState]()
    
    public func run() {
        sword.onVoiceChannelJoin { (member, voiceState) in
            if voiceState.channelId == KnownChannel.creakyRoof.snowflake {
                self.roofVoiceStatesByUserID[member.user.id] = voiceState
                log("\(member.user.debugIdenitifier) joined the creaky roof. There are now \(self.roofVoiceStatesByUserID.count) guests here.")
                self.moveRoofMembersIfNeeded()
            }
        }
        
        sword.onVoiceChannelLeave { (member, voiceState) in
            if voiceState.channelId == KnownChannel.creakyRoof.snowflake {
                self.roofVoiceStatesByUserID[member.user.id] = nil
                log("\(member.user.debugIdenitifier) left the creaky roof. There are now \(self.roofVoiceStatesByUserID.count) guests here.")
            }
        }
    }
    
    private func moveRoofMembersIfNeeded() {
        guard roofVoiceStatesByUserID.count >= 2 else {
            return
        }
        
        log("YIKES WE'RE FALLING IN")
        for (userID, _) in roofVoiceStatesByUserID {
            guild.moveMember(userID, to: KnownChannel.garage.snowflake) { (error) in
                if let error = error {
                    log(level: .error, "Could not move \(userID.rawValue) to garage: \(error)")
                } else {
                    log(level: .debug, "Moved \(userID.rawValue) to garage")
                    self.roofVoiceStatesByUserID[userID] = nil
                }
                self.notifyUserAboutRoofCollapse(userID)
            }
        }
    }
    
    private func notifyUserAboutRoofCollapse(_ userID: Snowflake) {
        log("Notifying \(userID) about room move")
        
        sword.getDM(for: userID) { (dm, error) in
            guard let dm = dm else {
                log(level: .error, "Invalid DM: \(String(describing: error))")
                return
            }
            
            let textOptions = [
                "Too many people on the creaky part of the roof was a bad idea. You've fallen through into some sort of garage. This isn't even on the mansion map... and there's a lot of cobwebs in here...",
                "Ouch! The creaky roof collapsed and your butt landed hard on the garage floor. Wait, there's a garage in this house?",
            ]
            
            self.sword.send(textOptions.randomElement()!, to: dm.id)
        }
    }
}
