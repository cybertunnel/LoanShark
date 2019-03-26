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
        
        Log.write(.debug, Log.Category.application, "Building Agent Menu.")
        
        item.menu = agentMenu
        item.title = "LoanShark"
        
        Log.write(.debug, Log.Category.application, "Agent Menu built.")
        
        
        Log.write(.info, Log.Category.application, "Checking loaner information")
        if let startDate = Preferences.sharedInstance.startDate, let endDate = Preferences.sharedInstance.endDate {
            Log.write(.debug, Log.Category.application, "Start Date: \(startDate.toString(format: "MM/dd/yyyy")) ; End DateL \(endDate.toString(format: "MM/dd/yyyy"))")
            let period = LoanPeriod(startDate: startDate, endDate: endDate)
            Log.write(.debug, Log.Category.application, period.description)
            self.willChangeValue(forKey: "loanerManager")
            Log.write(.debug, Log.Category.application, "Application setting loaner period in loaner manager")
            self.loanerManager.loanPeriod = period
            self.didChangeValue(forKey: "loanerManager")
            Log.write(.debug, Log.Category.application, "Application set loaner period in loaner manager")
        }
        
        
        Log.write(.info, Log.Category.application, "Checking loanee information")
        if let loanee = Preferences.sharedInstance.loaneeDetails {
            Log.write(.debug, Log.Category.application, "Loanee information found of: \(loanee.description)")
            self.willChangeValue(forKey: "loanerManager")
            Log.write(.debug, Log.Category.application, "Application setting loanee information in loaner manager")
            self.loanerManager.loanee = loanee
            self.didChangeValue(forKey: "loanerManager")
            Log.write(.debug, Log.Category.application, "Application set loanee information in loaner manager.")
        }
        
        
        Log.write(.info, Log.Category.application, "Checking tech information")
        if let tech = Preferences.sharedInstance.contactDetails {
            Log.write(.debug, Log.Category.application, "Tech information found of: \(tech.description)")
            self.willChangeValue(forKey: "loanerManager")
            Log.write(.debug, Log.Category.application, "Application setting tech/contact information in loaner manager")
            self.loanerManager.tech = tech
            self.didChangeValue(forKey: "loanerManager")
            Log.write(.debug, Log.Category.application, "Application has set tech/contact information in laoner manager")
        }
        
        Log.write(.info, Log.Category.application, "Enabling observer for notifications.")
        NotificationCenter.default.addObserver(self, selector: #selector(self.loanPeriodChanged(_:)), name: NSNotification.Name.loanerPeriodChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loanPeriodSet(_:)), name: NSNotification.Name.loanerPeriodSet, object: nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    private static func initialSetup() {
        
        Log.write(.info, Log.Category.application, "Beginning initial setup.")
        //  Value Transformers for bindings
        ValueTransformer.setValueTransformer(StatusTransformer(), forName: .statusTransformer)
        ValueTransformer.setValueTransformer(TimerTransformer(), forName: .timerTransformer)
        ValueTransformer.setValueTransformer(RemainingTransformer(), forName: .remainingTransformer)
        Log.write(.info, Log.Category.application, "Finished initial setup.")
    }
    
    @objc func loanPeriodChanged(_ aNotification: Notification) {
        Log.write(.debug, Log.Category.application, "Application detected a loan period change.")
        self.willChangeValue(forKey: "loanerManager")
        self.didChangeValue(forKey: "loanerManager")
    }
    
    @objc func loanPeriodSet(_ aNotification: Notification) {
        Log.write(.debug, Log.Category.application, "Application detected loaner period being set.")
        self.willChangeValue(forKey: "loanerManager")
        self.didChangeValue(forKey: "loanerManager")
    }
}

