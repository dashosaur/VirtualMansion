//
//  Errors.swift
//  
//
//  Created by Allan Shortlidge on 12/31/20.
//

import Foundation

enum VirtualMansionError: Error {
    case unknownChannel(value: UInt64)
}
