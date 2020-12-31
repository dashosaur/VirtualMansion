//
//  Database.swift
//  
//
//  Created by Allan Shortlidge on 12/31/20.
//

import Foundation
import SQLite

class Database {
    
    let path: String
    let connection: Connection
    
    init(path: String) throws {
        self.path = path
        self.connection = try Connection(path)
    }
    
}
