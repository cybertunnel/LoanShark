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
    @objc func loanerPeriodDidChange(_ notification: Notification) {
        Log.write(.info, Log.Category.statusListener, "Loaner period has changed.")
    }
    
    @objc func loanerPeriodSet(_ notification: Notification) {
        Log.write(.info, Log.Category.statusListener, "Loaner period has been set.")
    }
    
    @objc func loanerPeriodExpired(_ notification: Notification) {
        Log.write(.info, Log.Category.statusListener, "Loaner period has expired.")
    }
    
    override init() {
        Log.write(.debug, Log.Category.statusListener, "Listener has been started.")
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.loanerPeriodDidChange(_:)), name: NSNotification.Name.loanerPeriodChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loanerPeriodSet(_:)), name: NSNotification.Name.loanerPeriodSet, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loanerPeriodExpired(_:)), name: NSNotification.Name.loanerPeriodExpired, object: nil)
    }
}
