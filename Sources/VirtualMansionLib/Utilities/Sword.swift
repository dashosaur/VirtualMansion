//  Sword.swift
//  
//
//  Created by Dash on 12/31/20.
//

import Sword

extension Sword {
    func onVoiceChannelJoin(do action: @escaping (Member, VoiceState) -> Void) {
        on(.voiceChannelJoin) { data in
            guard let (userID, voiceState) = data as? (Snowflake, VoiceState) else {
                log(level: .error, "Invalid data of type: \(type(of: data))")
                return
            }
            log(level: .debug, "Joined voice channel\n  userID: \(userID)\n  Voice state: \(String(describing: voiceState))")
            
            self.getMember(userID, from: .publicHouse) { (member, error) in
                guard let member = member else {
                    log(level: .error, "Could not find member for \(userID): \(error.debugDescription)")
                    return
                }
                action(member, voiceState)
            }
        }
    }
    
    func onVoiceChannelLeave(do action: @escaping (Member, VoiceState) -> Void) {
        on(.voiceChannelLeave) { data in
            guard let (userID, voiceState) = data as? (Snowflake, VoiceState) else {
                log(level: .error, "Invalid data of type: \(type(of: data))")
                return
            }
            log(level: .debug, "Left voice channel\n  userID: \(userID)\n  Voice state: \(String(describing: voiceState))")
            
            self.getMember(userID, from: .publicHouse) { (member, error) in
                guard let member = member else {
                    log(level: .error, "Could not find member for \(userID): \(error.debugDescription)")
                    return
                }
                action(member, voiceState)
            }
        }
    }
}
