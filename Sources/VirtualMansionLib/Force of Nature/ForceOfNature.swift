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
    
    public func run() {
        sword.onVoiceChannelJoin { (member, voiceState) in
            if voiceState.channelId == KnownChannel.creakyRoof.snowflake {
                self.joinedRoof(member: member, voiceState: voiceState)
            } else if self.roofVoiceStatesByUserID[member.user.id] != nil {
                self.leftRoof(member: member)
            }
            
            if voiceState.channelId == KnownChannel.hotTub.snowflake {
                self.joinedHotTub(member: member, voiceState: voiceState)
            } else if self.hotTubVoiceStatesByUserID[member.user.id] != nil {
                self.leftHotTub(member: member)
            }
        }
        
        sword.onVoiceChannelLeave { (member) in
            if self.roofVoiceStatesByUserID[member.user.id] != nil {
                self.leftRoof(member: member)
            }
            if self.hotTubVoiceStatesByUserID[member.user.id] != nil {
                self.leftHotTub(member: member)
            }
        }
    }
    
    // MARK: - Hot Tub
    
    private var hotTubVoiceStatesByUserID = [Snowflake : VoiceState]()
    private var hotTubVoiceChannel: GuildVoice? = nil
    
    private func joinedHotTub(member: Member, voiceState: VoiceState) {
        hotTubVoiceStatesByUserID[member.user.id] = voiceState
        log("\(member.user.debugIdenitifier) joined the hot tub. There are now \(hotTubVoiceStatesByUserID.count) guests here.")
        expandHotTubIfNeeded(lastMember: member)
    }
    
    private func leftHotTub(member: Member) {
        hotTubVoiceStatesByUserID[member.user.id] = nil
        log("\(member.user.debugIdenitifier) left the hot tub. There are now \(hotTubVoiceStatesByUserID.count) guests here.")
        shrinkHotTubIfNeeded(lastMember: member)
    }
    
    private func perform(action: @escaping (GuildVoice) -> Void) {
        sword.getChannel(KnownChannel.hotTub.snowflake, rest: true) { (channel, error) in
            guard let voiceChannel = channel as? GuildVoice else {
                log(level: .error, "Could not find channel for \(KnownChannel.hotTub.snowflake.rawValue): \(error.debugDescription)")
                return
            }
            action(voiceChannel)
        }
    }
    
    private func expandHotTubIfNeeded(lastMember: Member) {
        perform { channel in
            guard let userLimit = channel.userLimit, self.hotTubVoiceStatesByUserID.count >= userLimit else {
                log(level: .debug, "\(self.hotTubVoiceStatesByUserID.count)/\(channel.userLimit ?? 0) guests. No need to expand the hot tub.")
                return
            }
            
            let capacity = self.hotTubVoiceStatesByUserID.count + 1
            log("Expanding the hot tub so we can have \(capacity) friends here.")
            
            self.sword.modifyChannel(channel.id, with: ["user_limit" : capacity]) { (channel, error) in
                if let error = error {
                    log(level: .error, "Could not modify channel for \(KnownChannel.hotTub.snowflake.rawValue): \(error.description)")
                    return
                }
                log(level: .debug, "Updated hot tub capacity to \(capacity)")
                
                let message = "\(lastMember.user.username ?? "Someone") slips into the last spot in the hot tub, but a Public House hot tub always has room for one more. The capacity has expanded to \(capacity). Invite your friends to join!"
                self.notifyHotTubGuests(message: message)
            }
        }
    }
    
    private static let defaultCapacity = 3
    
    private func shrinkHotTubIfNeeded(lastMember: Member) {
        perform { channel in
            guard let userLimit = channel.userLimit, userLimit > Self.defaultCapacity, userLimit - self.hotTubVoiceStatesByUserID.count > 1 else {
                log(level: .debug, "\(self.hotTubVoiceStatesByUserID.count)/\(channel.userLimit ?? 0) guests. No need to shrink the hot tub.")
                return
            }
            
            let capacity = max(self.hotTubVoiceStatesByUserID.count + 1, Self.defaultCapacity)
            log("Shrinking the hot tub so we can have \(capacity) friends here.")
            
            self.sword.modifyChannel(channel.id, with: ["user_limit" : capacity]) { (channel, error) in
                if let error = error {
                    log(level: .error, "Could not modify channel for \(KnownChannel.hotTub.snowflake.rawValue): \(error.description)")
                    return
                }
                log(level: .debug, "Updated hot tub capacity to \(capacity)")
                
                let message = "\(lastMember.user.username ?? "Someone") leaves the hot tub and it shrinks a bit just to conserve water."
                self.notifyHotTubGuests(message: message)
            }
        }
    }
    
    private func notifyHotTubGuests(message: String) {
        for userID in hotTubVoiceStatesByUserID.keys {
            sword.getDM(for: userID) { (dm, error) in
                guard let dm = dm else {
                    log(level: .error, "Invalid DM: \(String(describing: error))")
                    return
                }
                
                self.sword.send(message, to: dm.id)
            }
        }
    }
    
    // MARK: - Roof
    
    private var roofVoiceStatesByUserID = [Snowflake : VoiceState]()
    
    private func joinedRoof(member: Member, voiceState: VoiceState) {
        roofVoiceStatesByUserID[member.user.id] = voiceState
        log("\(member.user.debugIdenitifier) joined the creaky roof. There are now \(self.roofVoiceStatesByUserID.count) guests here.")
        collapseRoofIfNeeded()
    }
    
    private func leftRoof(member: Member) {
        roofVoiceStatesByUserID[member.user.id] = nil
        log("\(member.user.debugIdenitifier) left the creaky roof. There are now \(self.roofVoiceStatesByUserID.count) guests here.")
    }
    
    private func collapseRoofIfNeeded() {
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
