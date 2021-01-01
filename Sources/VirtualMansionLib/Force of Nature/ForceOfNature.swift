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
    
    private var countInRoof = 0
    
    public func run() {
        sword.onVoiceChannelJoin { (member, voiceState) in
            if voiceState.channelId.rawValue == KnownChannel.slopedRoof.rawValue {
                self.countInRoof += 1
                
                log("\(member.user.debugIdenitifier) joined the sloped roof. There are now \(self.countInRoof) guests here.")
                
                if self.countInRoof >= 10 {
                    log("YIKES WE'RE FALLING IN")
                }
            }
        }
        
        print(guild.voiceStates)
        
        sword.onVoiceChannelLeave { (member, voiceState) in
            if voiceState.channelId.rawValue == KnownChannel.slopedRoof.rawValue {
                self.countInRoof -= 1
            }
        }
    }
}
