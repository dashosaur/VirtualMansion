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
        channelVisits[.amongUsTable] = 1
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
    
    func testSleuthAward() throws {
        channelVisits = [
            .hallwayMirrorReverse: 1,
            .blanketFort: 1,
            .slopedRoof: 1,
            .creakyRoof: 1,
            .fatefulCup: 1,
            .redCouch: 1,
            .narnia: 1,
            .caveOfTime: 1,
            .caveOpening: 1,
        ]

        XCTAssertEqual(evaluate(), [])
        
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
