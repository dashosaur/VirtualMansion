//  User.swift
//  
//
//  Created by Dash on 12/31/20.
//

import Sword

extension User {
    var debugIdenitifier: String {
        if let username = username {
            let name = "@\(username)".cyan()
            return "\(name) (\(String(id.rawValue)))"
        } else {
            return String(id.rawValue)
        }
    }
    
    var userTag: String? {
        "<@\(id.rawValue)>"
    }
}
