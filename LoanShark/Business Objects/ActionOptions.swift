//
//  ActionOptions.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/5/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Foundation

/**
 Extension options used to display to the user, and used to alert the program of a request change.
 */
struct ActionOptions {
    static let oneDay = NSUserNotificationAction(identifier: "1Day", title: "1 Day")
    static let threeDays = NSUserNotificationAction(identifier: "3Days", title: "3 Days")
    static let sevenDays = NSUserNotificationAction(identifier: "7Days", title: "7 Days")
    static let fourteenDays = NSUserNotificationAction(identifier: "14Days", title: "14 Days")
    static let thirtyDays = NSUserNotificationAction(identifier: "30Days", title: "30 Days")
}
