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
    
    
    @objc var testText: String = "Testing"
    @objc let loanerManager = LoanManager.sharedInstance
    private let dontUse: Any? = initialSetup()
    //  MARK: IBOutlets
    
    //  Menu that is displayed in the top Apple Menubar
    @IBOutlet weak var agentMenu: AgentMenu!

    //  MARK: Variables
    
    let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    
    //  MARK: Functions
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        item.menu = agentMenu
        item.title = "LoanShark"
        
        self.agentMenu.startListening()
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    private static func initialSetup() {
        
        //  Value Transformers for bindings
        ValueTransformer.setValueTransformer(StatusTransformer(), forName: .statusTransformer)
        ValueTransformer.setValueTransformer(TimerTransformer(), forName: .timerTransformer)
        
        if let loanee = Preferences.sharedInstance.loaneeDetails {
            LoanManager.sharedInstance.setLoanee(loanee)
        }
        
        if let tech = Preferences.sharedInstance.contactDetails {
            LoanManager.sharedInstance.setTech(tech)
        }
        
        if let startDate = Preferences.sharedInstance.startDate, let endDate = Preferences.sharedInstance.endDate {
            let period = LoanPeriod(startDate: startDate, endDate: endDate)
            LoanManager.sharedInstance.loanPeriod = period
        }
    }


}

