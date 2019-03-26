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
        if let statusInt = value as? UInt {
            let status = LoanManager.Status.init(rawValue: statusInt)
            return "Status: \(status!.toString())"
        } else {
            return "Status: Not Set"
        }
    }
}

extension NSValueTransformerName {
    static let statusTransformer = NSValueTransformerName(rawValue: "StatusTransformer")
}
