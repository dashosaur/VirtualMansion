//  KnownChannel.swift
//  
//
//  Created by Dash on 12/31/20.
//

import Foundation
import Sword

enum KnownChannel: UInt64 {
    // Foyer
    case techSupport = 794094637920288768 // Secret, but not for fun
    
    // Ground Floor
    case hallwayMirror = 793709576112570429
    case hallwayMirrorReverse = 794080225645953055 // Secret
    case parlor = 715830839862362144
    case sunRoom = 794040002073722890
    case cloakroom = 793709176118968342
    case library = 792972303419310153
    case broomCloset = 792960131759472680
    case powderRoom = 793719742040637440
    case pantry = 793719649740128288
    case garage = 794370628840587274 // Secret, fall through from Creaky Roof
    
    // 2nd Floor
    case bayWindowSeat = 793708380762013717
    case theater = 792972925913399316
    case dustinsRoom = 793725632060194836
    case blanketFort = 792996672740655145 // Secret
    case quietRoom = 792997378293628958
    case jamRoom = 792998360407736352
    case wardrobe = 793717805169115176
    case bathroom = 793739712153911326
    
    // 3rd Floor
    case turret = 792973260815597569
    case observatory = 793709369086705737
    case slopedRoof = 793710314741956648 // Secret, reach from Observatory
    case creakyRoof = 794369749348909066 // Secret, reach from Sloped Roof
    
    // Backyard
    case firepit = 792970916330078228
    case hotTub = 715830314588569660
    case treehouse = 792998011310702614
    case fatefulCup = 793713174087204864 // Secret
    
    // Games Attic
    case largeTable = 792982727258931200
    case mediumTable = 792996218666090507
    case smallTable = 792996270737457152
    case amongUsTable = 793695380537081886
    case jackboxTable = 793695440373284864
    
    // Dance Hall
    case lounge = 715829291144970355
    case redCouch = 794116339056246795 // Secret
    case swingFloor = 792967301548605451
    case discotheque = 792990531180429342
    
    // Adventure
    case narnia = 793747690621108274 // Secret, may be deleted?
    case caveOfTime = 794105543639826473 // Secret
    case caveOpening = 794113728588546088 // Secret
    
    // Text
    case awardAnnouncements = 794107875940368385
    
    var snowflake: Snowflake {
        Snowflake(rawValue: rawValue)
    }
}

extension KnownChannel {
    static let gamerChannels: Set<KnownChannel> = Set([
        .largeTable,
        .mediumTable,
        .smallTable,
        .amongUsTable,
        .jackboxTable,
    ])
    
    static let secretChannels: Set<KnownChannel> = Set([
        .hallwayMirrorReverse,
        .garage,
        .blanketFort,
        .slopedRoof,
        .creakyRoof,
        .redCouch,
        .narnia,
    ])
}

extension Snowflake {
    var knownChannel: KnownChannel? {
        KnownChannel(rawValue: rawValue)
    }
    
    func getKnownChannel() throws -> KnownChannel {
        if let channel = knownChannel {
            return channel
        } else {
            throw VirtualMansionError.unknownChannel(value: rawValue)
        }
    }
}
