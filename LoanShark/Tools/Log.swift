//
//  Log.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/5/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Foundation
import os.log


class Log {
    
    
    //MARK: Structs
    struct Category {
        static let application = "Application"
        static let view = "View"
        static let loanManager = "LoanManager"
        static let statusListener = "StatusListener"
    }
    
    
    //MARK: Enumerations
    enum Level: UInt8 {
        case debug = 2, error = 16, fault = 17, info = 1
        func toString() -> String {
            switch self {
            case .debug:
                return "DEBUG"
            case .error:
                return "ERROR"
            case .fault:
                return "FAULT"
            case .info:
                return "INFO"
            }
        }
    }
    
    //MARK: Variables
    static let appName = "com.github.cybertunnel.LoanShark"
    
    
    //MARK: Functions
    static func write(_ level: Level, _ category: String, _ message: String) {
        let log = OSLog(subsystem: level.toString(), category: category)
        os_log("%{public}@", log: log, type: OSLogType(level.rawValue), message)
    }
}
