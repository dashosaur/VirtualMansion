//  Log.swift
//  
//
//  Created by Dash on 12/31/20.
//

import Foundation
import os

var verboseLoggingEnabled = false

enum LogLevel {
    case `default`
    case error
    case debug
}

func log(level: LogLevel = .default, _ string: String) {
    switch level {
    case .default:
        print(string)
    case .error:
        print("ERROR: " + string)
    case .debug:
        if verboseLoggingEnabled {
            print(string)
        }
    }
}
