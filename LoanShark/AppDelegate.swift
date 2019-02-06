//
//  AppDelegate.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/5/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    
    //  MARK: IBOutlets
    
    //  Menu that is displayed in the top Apple Menubar
    @IBOutlet weak var agentMenu: NSMenu!

    //  MARK: Variables
    
    let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let listener = StatusListener()
    let loanerManager = LoanManager.sharedInstance
    
    
    //  MARK: Functions
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        item.menu = agentMenu
        item.title = "LoanShark"
        
        ValueTransformer.setValueTransformer(TimerTransformer(), forName: .timerTransformer)
        
        if let loanee = Preferences.sharedInstance.loaneeDetails {
            self.loanerManager.setLoanee(loanee)
        }
        
        if let tech = Preferences.sharedInstance.contactDetails {
            self.loanerManager.setTech(tech)
        }
        
        if let startDate = Preferences.sharedInstance.startDate, let endDate = Preferences.sharedInstance.endDate {
            let period = LoanPeriod(startDate: startDate, endDate: endDate)
            self.loanerManager.loanPeriod = period
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

