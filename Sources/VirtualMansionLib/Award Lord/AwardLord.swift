//
//  AwardLord.swift
//  
//
//  Created by Allan Shortlidge on 12/31/20.
//

import Foundation
import Sword

public struct AwardLord: Bot {
    private let sword: Sword
    private let guild: Guild
    private let database: Database
    
    public var botName: String { "Award Lord" }

    public init(sword: Sword, guild: Guild, database: Database) {
        self.sword = sword
        self.guild = guild
        self.database = database
    }
    
    public func run() {
        sword.editStatus(to: "online", playing: "judging your achievements")
        
        sword.onVoiceChannelJoin { (member, voiceState) in
            do {
                try onChannelJoin(userID: member.user.id, voiceState: voiceState)
            } catch {
                log(level: .error, "Failed to handle channel join: \(error)")
            }
            
            // TODO: remove once we have a generic engine
            if voiceState.channelId.rawValue == KnownChannel.largeTable.rawValue {
                sword.grantAward(.gamer, to: member)
            }
        }

        sword.on(.messageCreate) { data in
            let msg = data as! Message
            
            if msg.content == "!ping" {
                msg.reply(with: "Pong (Award Lord)!")
            }
        }
    }
    
    func onChannelJoin(userID: Snowflake, voiceState: VoiceState) throws {
        guard let knownChannel = voiceState.channelId.knownChannel else {
            throw VirtualMansionError.unknownChannel // ALLANXXX
        }
        
        try database.addVisit(to: knownChannel, by: userID.rawValue)
        
        // TODO: Call engine.eval(for: userID, with: [Channel: Count])
    }

}
