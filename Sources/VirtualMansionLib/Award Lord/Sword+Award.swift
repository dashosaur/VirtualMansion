//  Sword+Award.swift
//  
//
//  Created by Dash on 12/31/20.
//

import Sword

extension Sword {
    func grantAward(_ award: Award, to userID: Snowflake) {
        getMember(userID, from: .publicHouse) { (member, error) in
            guard let member = member else {
                log(level: .error, "Could not find member for \(userID): \(error.debugDescription)")
                return
            }
            self.grantAward(award, to: member)
        }
    }
    
    private func grantAward(_ award: Award, to member: Member) {
        let currentRoles = member.roles.map { $0.id.rawValue }
        guard !currentRoles.contains(award.rawValue) else {
            log(level: .error, "\(member.user.debugIdenitifier) already has the \(award) award, ignoring request to grant")
            return
        }
        
        let roleUpdate = ["roles" : currentRoles + [award.rawValue]]
        modifyMember(member.user.id, in: .publicHouse, with: roleUpdate) { (error) in
            if let error = error {
                log(level: .error, "Could not grant award \(award) to \(member.user.debugIdenitifier): \(error)")
            } else {
                log("Granted award \(award) to \(member.user.debugIdenitifier)")
            }
            
            self.notifyGrantedAward(award, to: member)
        }
    }
    
    private func notifyGrantedAward(_ award: Award, to member: Member) {
        guard let userTag = member.user.userTag else {
            log(level: .error, "Could not retrieve user tag for \(member.user.debugIdenitifier)")
            return
        }
        
        let text = award.randomAnnouncementFormat
            .replacingOccurrences(of: "<user>", with: userTag)
            .replacingOccurrences(of: "<award>", with: award.inlineName)
        
        send(text, to: KnownChannel.awardAnnouncements.snowflake) { (message, error) in
            if let error = error {
                log(level: .error, "Could not notify award \(award) granted to \(member.user.debugIdenitifier): \(error)")
            } else {
                log(level: .debug, "Notified about award \(award) granted to \(member.user.debugIdenitifier): \(message?.content ?? "nil")")
            }
        }
    }
}

extension Member {
    var awards: [Award] {
        roles.compactMap { Award(rawValue: $0.id.rawValue) }
    }
}
