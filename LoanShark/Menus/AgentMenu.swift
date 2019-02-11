//
//  AgentMenu.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/6/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa

class AgentMenu: NSMenu, NSUserNotificationCenterDelegate {
    
    
    //  MARK: Cocoa Binding Resources
    @objc var configured: Bool = false {
        willSet {
            self.willChangeValue(forKey: "configured")
        }
        didSet {
            self.didChangeValue(forKey: "configured")
        }
    }
    @objc func loanerPeriodDidChange(_ notification: Notification) {
        Log.write(.info, Log.Category.statusListener, "Loaner period has changed.")
    }
    
    @objc func loanerPeriodSet(_ notification: Notification) {
        Log.write(.info, Log.Category.statusListener, "Loaner period has been set.")
        self.configured = true
        
    }
    
    @objc func loanerPeriodExpired(_ notification: Notification) {
        Log.write(.info, Log.Category.statusListener, "Loaner period has expired.")
    }
    
    @objc var loanerManager = LoanManager.sharedInstance
    
    func startListening() {
        Log.write(.debug, Log.Category.statusListener, "Listener has been started.")
        NotificationCenter.default.addObserver(self, selector: #selector(self.loanerPeriodDidChange(_:)), name: NSNotification.Name.loanerPeriodChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loanerPeriodSet(_:)), name: NSNotification.Name.loanerPeriodSet, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loanerPeriodExpired(_:)), name: NSNotification.Name.loanerPeriodExpired, object: nil)
    }
    
}
