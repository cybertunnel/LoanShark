//
//  AgentMenu.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/6/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa

class AgentMenu: NSMenu, NSUserNotificationCenterDelegate {
    
    @IBOutlet weak var statusTitle: NSMenuItem!
    @IBOutlet weak var remainingTitle: NSMenuItem!
    @IBOutlet weak var requestTitle: NSMenuItem!
    @IBOutlet weak var loaneeTitle: NSMenuItem!
    @IBOutlet weak var loaneeMenu: NSMenu!
    @IBOutlet weak var assignedUser: NSMenuItem!
    @IBOutlet weak var assignedEmail: NSMenuItem!
    @IBOutlet weak var assignedPhone: NSMenuItem!
    @IBOutlet weak var techEmail: NSMenuItem!
    @IBOutlet weak var techPhone: NSMenuItem!
    @IBOutlet weak var techTitle: NSMenuItem!
    @IBOutlet weak var techMenu: NSMenu!
    @IBOutlet weak var adminMenu: NSMenu!
    @IBOutlet weak var adminConfigure: NSMenuItem!
    @IBOutlet weak var adminExtend: NSMenuItem!
    
    
    
    func startListening() {
        Log.write(.debug, Log.Category.statusListener, "Listener has been started.")
        //NotificationCenter.default.addObserver(self, selector: #selector(self.loanerPeriodDidChange(_:)), name: NSNotification.Name.loanerPeriodChanged, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(self.loanerPeriodSet(_:)), name: NSNotification.Name.loanerPeriodSet, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(self.loanerPeriodExpired(_:)), name: NSNotification.Name.loanerPeriodExpired, object: nil)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        LoanManager.sharedInstance.addCallback {
            DispatchQueue.main.async {
                
                // MARK: LoanPeriod Not Set Handling
                if LoanManager.sharedInstance.loanPeriod == nil {
                    self.loaneeTitle.isHidden = true
                    self.techTitle.isHidden = true
                    self.remainingTitle.isHidden = true
                    self.requestTitle.isHidden = true
                    self.adminExtend.isHidden = true
                    self.adminConfigure.isHidden = false
                }
                else {
                    self.loaneeTitle.isHidden = false
                    self.techTitle.isHidden = false
                    self.remainingTitle.isHidden = false
                    self.requestTitle.isHidden = false
                    self.adminExtend.isHidden = false
                    self.adminConfigure.isHidden = true
                    
                    // Update Menu Text
                    self.remainingTitle.title = "Remaining: \(LoanManager.sharedInstance.loanPeriod?.remaining ?? 0)"
                    self.techEmail.title = LoanManager.sharedInstance.techEmail ?? "UNKNOWN"
                    self.techPhone.title = LoanManager.sharedInstance.techPhone ?? "UNKNOWN"
                    self.assignedUser.title = LoanManager.sharedInstance.loaneeName ?? "UNKNOWN"
                    self.assignedEmail.title = LoanManager.sharedInstance.loaneeEmail ?? "UNKNOWN"
                    self.assignedPhone.title = LoanManager.sharedInstance.loaneePhone ?? "UNKNOWN"
                }
                // Status
                self.statusTitle.title = "Status: \(LoanManager.sharedInstance.loanStatus.rawValue)"
            }
        }
    }
}
