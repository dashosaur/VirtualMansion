//
//  DatabaseTests.swift
//  
//
//  Created by Allan Shortlidge on 12/31/20.
//

import XCTest
@testable import VirtualMansionLib

final class DatabaseTests: XCTestCase {
    
    func testExample() throws {
        _ = try Database(path: "/tmp/testdb.sqlite")
    }
    
}
