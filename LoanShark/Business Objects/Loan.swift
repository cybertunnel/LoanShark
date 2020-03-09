//
//  Loan.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/5/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Foundation

/**
 Loan period object, this is used to determine the loaner period duration.
 */
class Loan: NSObject {
    
    
    //MARK: Variables
    
    // The date which the loan started
    let start: Date
    
    //  The date which the loan will expire
    let end: Date
    
    //  The remaining duration of the loan in days
    var remaining: Int {
        get {
            return self.end.days(from: Date())
        }
    }
    
    //MARK: Initializers
    
    /**
        - Parameters:
            - startDate: The date which the loan will begin on.
            - endDate: The date which the loan will expire on.
     */
    init (startDate start: Date, endDate end: Date) {
        self.start = start
        self.end = end
    }
}
