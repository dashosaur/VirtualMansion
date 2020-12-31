//  KnownChannel.swift
//  
//
//  Created by Dash on 12/31/20.
//

import Foundation
import Sword

enum KnownChannel: UInt64 {
    case hallwayMirror = 793709576112570429
    case hallwayMirrorReverse = 794080225645953055
}

extension Snowflake {
    var knownChannel: KnownChannel? {
        KnownChannel(rawValue: rawValue)
    }
}
