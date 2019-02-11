//
//  LoanPeriod.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/5/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Foundation

/**
 Loan period object, this is used to determine the loaner period duration.
 */
@objc class LoanPeriod: NSObject {
    
    
    //MARK: Variables
    let start: Date
    let end: Date
    
    var remaining: Int {
        get {
            return self.end.days(from: Date())
        }
    }
    
    //MARK: Initializers
    
    init (startDate start: Date, endDate end: Date) {
        self.start = start
        self.end = end
    }
}
