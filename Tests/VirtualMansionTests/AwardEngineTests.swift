//
//  AwardEngineTests.swift
//  
//
//  Created by Allan Shortlidge on 12/31/20.
//

import XCTest
@testable import VirtualMansionLib

final class AwardEngineTests: XCTestCase {
    
    static let defaultEngine: AwardEngine = {
        var engine = AwardEngine()
        engine.setUpDefaultEvaluators()
        return engine
    }()
    
    var channelVisits: [KnownChannel: Int] = [:]
    var existingAwards: Set<Award> = Set()
    
    func testEmptyVisitsEmptyAwards() throws {
        XCTAssertEqual(evaluate(), [])
    }
    
    func testGamerAward() throws {
        channelVisits[.jackboxTable] = 1
        XCTAssertEqual(evaluate(), [.gamer])
        XCTAssertEqual(evaluate(), [])
    }
    
    func testNarcissisticNarwhalAward() throws {
        channelVisits[.hallwayMirror] = 9
        XCTAssertEqual(evaluate(), [])
        
        channelVisits[.hallwayMirror] = 10
        XCTAssertEqual(evaluate(), [.narcissisticNarwhal])
        XCTAssertEqual(evaluate(), [])
        
        channelVisits[.hallwayMirror] = 11
        XCTAssertEqual(evaluate(), [])
    }
    
    func testSecretChannelAwards() throws {
        channelVisits = [
            .parlor: 1,
        ]

        XCTAssertEqual(evaluate(), [])
        
        channelVisits[.hallwayMirrorReverse] = 1

        XCTAssertEqual(evaluate(), [.gumshoe])
        
        channelVisits[.hallwayMirrorReverse] = 1
        channelVisits[.blanketFort] = 1
        channelVisits[.slopedRoof] = 1
        channelVisits[.creakyRoof] = 1
        channelVisits[.fatefulCup] = 1
        channelVisits[.redCouch] = 1
        channelVisits[.narnia] = 1

        XCTAssertEqual(evaluate(), [.privateEye])

        channelVisits[.garage] = 1
        XCTAssertEqual(evaluate(), [.sleuth])
        XCTAssertEqual(evaluate(), [])
    }

    // MARK: -
    
    func evaluate() -> [Award] {
        let userState = AwardEngine.UserState(channelVisits: channelVisits, existingAwards: existingAwards)
        let newAwards = Self.defaultEngine.evaluateAwards(userState: userState)
        newAwards.forEach { existingAwards.insert($0) }
        return newAwards
    }
}
