//
//  TimerTransformer.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/5/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa

class TimerTransformer: ValueTransformer {
    class func transformedValueClass(_ value: Any?) -> Any? {
        return String.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        let timer = value as! String
        let timerValue = Int(timer) ?? 0
        let hours = timerValue / 60
        let minutes = timerValue - (60 * hours)
        if minutes < 10 {
            return String(describing: hours) + ":0" + String(describing: minutes)
        }
        else {
            return String(describing: hours) + ":" + String(describing: minutes)
        }
    }
}

extension NSValueTransformerName {
    static let timerTransformer = NSValueTransformerName(rawValue: "TimerTransformer")
}
