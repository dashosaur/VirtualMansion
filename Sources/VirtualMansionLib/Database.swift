//
//  Database.swift
//  
//
//  Created by Allan Shortlidge on 12/31/20.
//

import Foundation
import SQLite

protocol DatabaseTable {
    func createTable(with connection: Connection) throws
}

struct Visits: DatabaseTable {
    
    let table = Table("visits")
    let user = Expression<Int64>("user_id")
    let channel = Expression<Int64>("channel_id")
    let count = Expression<Int64>("count")
    let lastVisitedAt = Expression<Double>("last_visited_at")

}

public class Database {
    
    let connection: Connection
    
    // Visits table
    let visits = Visits()
    
    public init(path: String?) throws {
        if let path = path {
            self.connection = try Connection(path)
        } else {
            self.connection = try Connection(.inMemory)
        }
        try createTables()
    }
    
    func createTables() throws {
        let tables = [visits]
        try tables.forEach {
            try $0.createTable(with: connection)
        }
    }
    
    func addVisit(to channel: KnownChannel, by user: UInt64) throws {
        try visits.upsert(with: connection, channel: Int64(channel.rawValue), user: Int64(user), lastVisit: Date())
    }
    
    func fetchChannelVisitCounts(for user: UInt64) throws -> [KnownChannel: Int] {
        try visits.fetchChannelVisitCounts(with: connection, for: Int64(user)).reduce(into: [:]) { result, entry in
            if let knownChannel = KnownChannel(rawValue: UInt64(entry.key)) {
                result[knownChannel] = Int(entry.value)
            } else {
                log(level: .error, "Unknown channel ID \(entry.key)")
            }
        }
    }
    
}

// MARK: -

extension Visits {
    
    func createTable(with connection: Connection) throws {
        try connection.run(table.create(ifNotExists: true) { t in
            t.column(user)
            t.column(channel)
            t.column(count)
            t.column(lastVisitedAt)
            t.unique(user, channel)
        })
    }

    func upsert(with connection: Connection, channel: Int64, user: Int64, lastVisit: Date) throws {
        let insertSQL = """
        INSERT INTO visits (user_id, channel_id, count, last_visited_at)
            VALUES(?, ?, 1, ?)
            ON CONFLICT(user_id, channel_id)
            DO UPDATE SET count=(count + 1), last_visited_at=excluded.last_visited_at;
        """
        
        let stmt = try connection.prepare(insertSQL)
        try stmt.run(user, channel, lastVisit.timeIntervalSinceReferenceDate)
    }
    
    func fetchChannelVisitCounts(with connection: Connection, for userID: Int64) throws -> [Int64: Int64] {
        let query = table.select(user, channel, count).filter(self.user == userID)
        var result = [Int64: Int64]()
        for row in try connection.prepare(query) {
            result[row[channel]] = row[count]
        }
        return result
    }
    
}
