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
    
    
    //  MARK: Cocoa Binding Resources
    @objc let loanerManager = LoanManager.sharedInstance
    
    //  Don't Use
    private let dontUse: Any? = initialSetup()
    
    
    //  MARK: IB Outlets
    
    //  Menu that is displayed in the top Apple Menubar
    @IBOutlet weak var agentMenu: AgentMenu!

    
    //  MARK: Variables
    
    let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    
    //  MARK: Functions
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        item.menu = agentMenu
        item.title = "LoanShark"
        
        if let startDate = Preferences.sharedInstance.startDate, let endDate = Preferences.sharedInstance.endDate {
            let period = LoanPeriod(startDate: startDate, endDate: endDate)
            self.willChangeValue(forKey: "loanerManager")
            self.loanerManager.loanPeriod = period
            self.didChangeValue(forKey: "loanerManager")
        }
        
        if let loanee = Preferences.sharedInstance.loaneeDetails {
            self.willChangeValue(forKey: "loanerManager")
            self.loanerManager.loanee = loanee
            self.didChangeValue(forKey: "loanerManager")
        }
        
        if let tech = Preferences.sharedInstance.contactDetails {
            self.willChangeValue(forKey: "loanerManager")
            self.loanerManager.tech = tech
            self.didChangeValue(forKey: "loanerManager")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loanPeriodChanged(_:)), name: NSNotification.Name.loanerPeriodChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loanPeriodSet(_:)), name: NSNotification.Name.loanerPeriodSet, object: nil)
        
        /**
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
 */
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    private static func initialSetup() {
        
        //  Value Transformers for bindings
        ValueTransformer.setValueTransformer(StatusTransformer(), forName: .statusTransformer)
        ValueTransformer.setValueTransformer(TimerTransformer(), forName: .timerTransformer)
        ValueTransformer.setValueTransformer(RemainingTransformer(), forName: .remainingTransformer)
    }
    
    @objc func loanPeriodChanged(_ aNotification: Notification) {
        self.willChangeValue(forKey: "loanerManager")
        self.didChangeValue(forKey: "loanerManager")
    }
    
    @objc func loanPeriodSet(_ aNotification: Notification) {
        self.willChangeValue(forKey: "loanerManager")
        self.didChangeValue(forKey: "loanerManager")
    }
}

