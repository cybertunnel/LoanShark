//
//  StatusListener.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/5/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Foundation

@objc class StatusListener: NSObject, NSUserNotificationCenterDelegate {
    
    static var sharedInstance = StatusListener()
    
    override init() {
    }
}
