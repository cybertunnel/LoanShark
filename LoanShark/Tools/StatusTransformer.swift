//
//  StatusTransformer.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/14/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa

class StatusTransformer: ValueTransformer {
    class func transformedValueClass(_ value: Any?) -> Any? {
        return String.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        if let status = value as? LoanManager.Status {
            switch status {
            case .active:
                return "Status: Active"
            case .critical:
                return "Status: Critical"
            case .expired:
                return "Status: Expired"
            case .notSet:
                return "Status: Not Configured"
            case .warning:
                return "Status: Warning"
            }
        }
        else {
            return "Status: Not Configured"
        }
    }
}

extension NSValueTransformerName {
    static let statusTransformer = NSValueTransformerName(rawValue: "StatusTransformer")
}
