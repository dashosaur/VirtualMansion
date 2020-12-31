//
//  Bot.swift
//  
//
//  Created by Allan Shortlidge on 12/31/20.
//

import Sword

public protocol Bot {
    init(sword: Sword, guild: Guild)
    func run()
}
