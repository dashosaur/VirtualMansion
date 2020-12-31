//
//  DatabaseTests.swift
//  
//
//  Created by Allan Shortlidge on 12/31/20.
//

import XCTest
@testable import VirtualMansionLib

final class DatabaseTests: XCTestCase {
    
    func testAddVisit() throws {
        let database = try Database(path: nil)
        let userA: UInt64 = 1, userB: UInt64 = 2
        
        let roomA = KnownChannel.hallwayMirror,
            roomB = KnownChannel.broomCloset
        
        // There should be no visits in an empty database.
        XCTAssert(try database.fetchChannelVisitCounts(for: userA).isEmpty)
        XCTAssert(try database.fetchChannelVisitCounts(for: userB).isEmpty)

        // Add a single visit for user A.
        try database.addVisit(to: roomA, by: userA)
        XCTAssertEqual(try database.fetchChannelVisitCounts(for: userA), [roomA: 1])
        XCTAssert(try database.fetchChannelVisitCounts(for: userB).isEmpty)

        // Add a visit to a new room for user A.
        try database.addVisit(to: roomB, by: userA)
        XCTAssertEqual(try database.fetchChannelVisitCounts(for: userA), [roomA: 1, roomB: 1])
        
        // Add a second visit to the first room for user A.
        try database.addVisit(to: roomA, by: userA)
        XCTAssertEqual(try database.fetchChannelVisitCounts(for: userA), [roomA: 2, roomB: 1])
    }
    
}
