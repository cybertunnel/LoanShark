//
//  AgentMenu.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/6/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa

class AgentMenu: NSMenu, NSUserNotificationCenterDelegate {
    
    func startListening() {
        Log.write(.debug, Log.Category.statusListener, "Listener has been started.")
        //NotificationCenter.default.addObserver(self, selector: #selector(self.loanerPeriodDidChange(_:)), name: NSNotification.Name.loanerPeriodChanged, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(self.loanerPeriodSet(_:)), name: NSNotification.Name.loanerPeriodSet, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(self.loanerPeriodExpired(_:)), name: NSNotification.Name.loanerPeriodExpired, object: nil)
    }
}
