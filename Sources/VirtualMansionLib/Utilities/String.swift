//  File.swift
//  
//
//  Created by Dash on 12/31/20.
//

import Foundation

extension String {
    func bold() -> String {
        "\u{001B}[1m\(self)\u{001B}[22m"
    }
    
    func italics() -> String {
        "\u{001B}[3m\(self)\u{001B}[23m"
    }
    
    func gray() -> String {
        "\u{001B}[37m\(self)\u{001B}[0m"
    }
    
    func cyan() -> String {
        "\u{001B}[36m\(self)\u{001B}[0m"
    }
    
    func pink() -> String {
        "\u{001B}[35m\(self)\u{001B}[0m"
    }
}
