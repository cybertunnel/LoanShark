//
//  RemainingTransformer.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/19/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa

class RemainingTransformer: ValueTransformer {
    class func transformedValueClass(_ value: Any?) -> Any? {
        return String.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        return "Remaining: \(String(describing: value ?? 0))"
    }
}

extension NSValueTransformerName {
    static let remainingTransformer = NSValueTransformerName(rawValue: "RemainingTransformer")
}
