//  Log.swift
//  
//
//  Created by Dash on 12/31/20.
//

import Foundation
import os

public var verboseLoggingEnabled = false

public enum LogLevel {
    case `default`
    case error
    case debug
}

public func log(level: LogLevel = .default, _ string: String) {
    switch level {
    case .default:
        print(string)
    case .error:
        print("ERROR: ".bold().pink() + string)
    case .debug:
        if verboseLoggingEnabled {
            print(string.italics())
        }
    }
}
