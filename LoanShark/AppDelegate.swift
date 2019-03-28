//
//  AppDelegate.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/5/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa
import UserNotifications

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    
    
    //  MARK: Cocoa Binding Resources
    @objc let loanerManager = LoanManager.sharedInstance
    
    //  Don't Use
    private let dontUse: Any? = initialSetup()
    private var lockoutWindow: LockoutWindowController!
    private var storyboard: NSStoryboard {
        return NSStoryboard(name: "Main", bundle: nil)
    }
    
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.loanPeriodExpired(_:)), name: NSNotification.Name.loanerPeriodExpired, object: nil)
        self.loanerManager.startPeriodChecker()
        if self.loanerManager.loanStatus == .notSet {
            self.sendUserNotification()
        }
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
        self.sendUserNotification()
    }
    
    @objc func loanPeriodSet(_ aNotification: Notification) {
        Log.write(.debug, Log.Category.application, "Application detected loaner period being set.")
        self.willChangeValue(forKey: "loanerManager")
        self.didChangeValue(forKey: "loanerManager")
    }
    
    @objc func loanPeriodExpired(_ aNotification: Notification) {
        Log.write(.info, Log.Category.application, "Loan period expired, displaying lockout message")
        if #available(OSX 10.13, *) {
            guard let lockoutWC = NSStoryboard.main?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(stringLiteral: "lockoutWindow")) as? LockoutWindowController else {
                Log.write(.error, Log.Category.application, "Unable to get lockout window controller")
                return
            }
            self.lockoutWindow = lockoutWC
        } else {
            guard let lockoutWC = self.storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(stringLiteral: "lockoutWindow")) as? LockoutWindowController else {
                Log.write(.error, Log.Category.application, "Unable to get lockout window controller")
                return
            }
            self.lockoutWindow = lockoutWC
        }
        
        self.lockoutWindow.loadWindow()
        self.lockoutWindow.showWindow(self)
    }
    
    private func sendUserNotification() {
        var title: String
        var message: String
        
        let notification = NSUserNotification()
        
        switch self.loanerManager.loanStatus {
        case .active:
            title = "Loan Period Active"
            if let endDate = self.loanerManager.loanPeriod?.end, let remaining = self.loanerManager.loanPeriod?.remaining {
                message = "You have \(String(describing: remaining)) days remaining on your loan. Ending on \(endDate.toString(format: "MM/dd/yyyy"))."
            } else {
                message = "You have \(String(describing: self.loanerManager.loanPeriod?.remaining ?? 0)) days remaining on your loan."
            }
            notification.title = title
            notification.informativeText = message
            notification.hasReplyButton = false
            notification.hasActionButton = false
            notification.soundName = NSUserNotificationDefaultSoundName
            NSUserNotificationCenter.default.deliver(notification)
            
        case .warning:
            title = "Loan Period Ending Soon"
            if let endDate = self.loanerManager.loanPeriod?.end, let remaining = self.loanerManager.loanPeriod?.remaining {
                message = "You have \(String(describing: remaining)) days remaining on your loan. Ending on \(endDate.toString(format: "MM/dd/yyyy"))."
            } else {
                message = "You have \(String(describing: self.loanerManager.loanPeriod?.remaining ?? 0)) days remaining on your loan."
            }
            notification.title = title
            notification.informativeText = message
            notification.deliveryDate = Date(timeIntervalSinceNow: 10)
            
            notification.hasReplyButton = false
            notification.hasActionButton = true
            notification.actionButtonTitle = "Request Extension"
            notification.otherButtonTitle = "Close"
            notification.soundName = NSUserNotificationDefaultSoundName
            NSUserNotificationCenter.default.delegate = self
            NSUserNotificationCenter.default.deliver(notification)
        case .critical:
            title = "Loan Period Ending Shortly"
            if let endDate = self.loanerManager.loanPeriod?.end, let remaining = self.loanerManager.loanPeriod?.remaining {
                message = "You have \(String(describing: remaining)) days remaining on your loan. Ending on \(endDate.toString(format: "MM/dd/yyyy"))."
            } else {
                message = "You have \(String(describing: self.loanerManager.loanPeriod?.remaining ?? 0)) days remaining on your loan."
            }
            notification.title = title
            notification.informativeText = message
            notification.hasReplyButton = false
            notification.hasActionButton = true
            notification.actionButtonTitle = "Request Extension"
            notification.otherButtonTitle = "Close"
            notification.soundName = NSUserNotificationDefaultSoundName
            NSUserNotificationCenter.default.deliver(notification)
        case .expired:
            title = "Loan Period has expired"
            if let endDate = self.loanerManager.loanPeriod?.end, let remaining = self.loanerManager.loanPeriod?.remaining {
                message = "You have \(String(describing: remaining)) days remaining on your loan. Ending on \(endDate.toString(format: "MM/dd/yyyy"))."
            } else {
                message = "You have \(String(describing: self.loanerManager.loanPeriod?.remaining ?? 0)) days remaining on your loan."
            }
            notification.title = title
            notification.informativeText = message
            notification.hasReplyButton = false
            notification.hasActionButton = true
            notification.actionButtonTitle = "Request Extension"
            notification.otherButtonTitle = "Close"
            notification.soundName = NSUserNotificationDefaultSoundName
            NSUserNotificationCenter.default.deliver(notification)
        case .notSet:
            title = "Loan Period not set"
            message = "Please configure before deploying this loaner."
            notification.title = title
            notification.informativeText = message
            notification.hasActionButton = true
            notification.hasReplyButton = false
            notification.actionButtonTitle = "Configure"
            notification.otherButtonTitle = "Close"
            notification.soundName = NSUserNotificationDefaultSoundName
            NSUserNotificationCenter.default.delegate = self
            NSUserNotificationCenter.default.deliver(notification)
            
        }
        
        
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        if notification.title == "Loan Period not set" {
            switch notification.activationType {
            case .actionButtonClicked:
                var controller: NSWindowController?
                if #available(OSX 10.13, *) {
                    controller = NSStoryboard.main?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("authentication")) as? NSWindowController
                } else {
                    controller = self.storyboard.instantiateController(withIdentifier: "authentication") as? NSWindowController
                }
                
                guard let view = controller?.window?.contentViewController as? AuthenticationViewController else {
                    return
                }
                
                view.destination = "configure"
                controller?.loadWindow()
                controller?.showWindow(self)
            default:
                print("Nothing")
            }
        }
        else {
            switch notification.activationType {
            case .actionButtonClicked:
                var controller: NSWindowController?
                if #available(OSX 10.13, *) {
                    controller = NSStoryboard.main?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("extensionRequest")) as? NSWindowController
                } else {
                    controller = self.storyboard.instantiateController(withIdentifier: "extensionRequest") as? NSWindowController
                }
                controller?.loadWindow()
                controller?.showWindow(self)
            default:
                print("Nothing")
            }
        }
    }
    
    
    
}

