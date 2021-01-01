//
//  AwardLord.swift
//  
//
//  Created by Allan Shortlidge on 12/31/20.
//

import Foundation
import Sword

public struct AwardLord: Bot {
    public var botName: String { "Award Lord" }
    private let database: Database
    private let engine: AwardEngine
    private let guild: Guild
    private let sword: Sword

    public init(sword: Sword, guild: Guild, database: Database) {
        self.sword = sword
        self.guild = guild
        self.database = database
        var engine = AwardEngine()
        engine.setUpDefaultEvaluators()
        self.engine = engine
    }
    
    public func run() {
        sword.editStatus(to: "online", playing: "achievement judge")
        log("Award Lord online.")

        sword.on(.voiceChannelJoin) { data in
            guard let (userID, voiceState) = data as? (Snowflake, VoiceState) else {
                log(level: .error, "Invalid data of type: \(type(of: data))")
                return
            }
            
            sword.getMember(userID, from: .publicHouse) { (member, error) in
                guard let member = member else {
                    log(level: .error, "Could not find member for \(userID): \(error.debugDescription)")
                    return
                }
                
                do {
                    try onChannelJoin(member: member, voiceState: voiceState)
                } catch {
                    log(level: .error, "Failed to handle channel join: \(error)")
                }
            }
        }

        sword.on(.messageCreate) { data in
            let msg = data as! Message
            
            if msg.content == "!ping" {
                msg.reply(with: "Pong (Award Lord)!")
            }
        }
    }
    
    func onChannelJoin(member: Member, voiceState: VoiceState) throws {
        let userID = member.user.id.rawValue
        let knownChannel = try voiceState.channelId.getKnownChannel()
        
        try database.addVisit(to: knownChannel, by: userID)
        let channelVisits = try database.fetchChannelVisitCounts(for: userID)
        
        let userState = AwardEngine.UserState(channelVisits: channelVisits, existingAwards: Set(member.awards))
        let newAwards = engine.evaluateAwards(userState: userState)
        if newAwards.count > 0 {
            log("Awarding user (\(userID)) \(newAwards)")

            newAwards.forEach {
                sword.grantAward($0, to: member)
            }
        }
    }
}
