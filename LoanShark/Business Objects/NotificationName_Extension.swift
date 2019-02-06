//
//  NotificationName_Extension.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/5/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Foundation

extension Notification.Name {
    /// Notification for when loaner period is modified.
    static let loanerPeriodChanged = Notification.Name(rawValue: "loanerPeriodChanged")
    static let loanerPeriodSet = Notification.Name(rawValue: "loanerPeriodSet")
    static let loanerPeriodExpired = Notification.Name(rawValue: "loanerPeriodExpired")
}
