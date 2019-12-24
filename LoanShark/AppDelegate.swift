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
    @objc let enableDebugging = Preferences.sharedInstance.enableDebugging
    
    //  Don't Use
    private var lockoutWindow: LockoutWindowController!
    private var storyboard: NSStoryboard {
        return NSStoryboard(name: "Main", bundle: nil)
    }
    
    
    //  MARK: IB Outlets
    
    //  Menu that is displayed in the top Apple Menubar
    @IBOutlet weak var agentMenu: AgentMenu!

    
    //  MARK: Variables
    
    let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let argParser = ArgumentParser()
    
    
    //  MARK: Functions
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        
        // MARK: Argument Parsing
        Log.write(.debug, Log.Category.argumentParser, "Building argument parsing.")
        
        //  Set Loan Period to Expired argument
        argParser.addArgument(name: "--set-expired", description: "Set loaner period to expired.", isBool: true) { (value) in
            Log.write(.info, Log.Category.application, "Set expiration argument sent, setting loaner period to expired.")
            print("Setting Loan Period to expired!")
            self.loanerManager.setExpired()
        }
        
        //  Perform extension argument
        //  Requires --passcode parameter as well
        argParser.addArgument(name: "--extend", description: "Extend loaner by set number of days.") { (value) in
            Log.write(.info, Log.Category.application, "Loaner extension argument passed, attempting to extend loaner")
            
            guard let passcode = value["--passcode"] else {
                Log.write(.fault, Log.Category.application, "--passcode was not passed, unable to authenticate.")
                throw ArgumentError.missingValue("Missing --passcode")
            }
            
            guard let sharedSecret = Preferences.sharedInstance.sharedSecret else {
                Log.write(.fault, Log.Category.application, "Shared secret not configured, please ensure this is configured before attempting to extend loaner period via. Command Line")
                throw ArgumentError.unsupportedArgument("Missing Shared Secret in preferences for --passcode or --extend to work properly.")
            }
            
            if passcode.sha256() == sharedSecret {
                Log.write(.info, Log.Category.application, "Provided passcode is correct, proceeding")
                guard let daysRaw = value["--extend"] else {
                    Log.write(.fault, Log.Category.application, "Unable to get extension amount.")
                    throw ArgumentError.missingValue("--extend")
                }
                
                guard let days = Int(daysRaw) else {
                    Log.write(.fault, Log.Category.application, "Unable to get number of days from provided input")
                    throw ArgumentError.invalidType(value: daysRaw, type: "Int", argument: "--extend")
                }
                
                try self.loanerManager.extend(extensionOf: (days + 1))
                print("Successfully extended loaner by \(String(describing: days)). Total loaning period remaining is now \(self.loanerManager.loanPeriod?.remaining ?? 0) days.")
                NSApp.terminate(self)
            }
            else {
                print("Invalid passcode provided, please try again.")
                Log.write(.error, Log.Category.application, "Passcode provided is invalid")
                NSApp.terminate(self)
            }
        }
        
        //  Authenticate using passcode
        argParser.addArgument(name: "--passcode", description: "Passcode to properly authenticate you") { (value) in
            
        }
        
        //  Get Loaner Status
        argParser.addArgument(name: "--status", description: "Get the loaner period status", isBool: true) { (_) in
            Log.write(.info, Log.Category.application, "Requested to provide loaner period status")
            print(self.loanerManager.loanStatus.rawValue)
            NSApp.terminate(self)
        }
        
        //  Get Loanee Details
        argParser.addArgument(name: "--loanee-details", description: "Get the loanee details", isBool: true) { (_) in
            Log.write(.info, Log.Category.application, "Requested to give loanee details, getting and providing loanee information")
            print(self.loanerManager.loanee?.description ?? "No Information to Provide")
            NSApp.terminate(self)
        }
        
        //  DEBUG: Get Preferences
        argParser.addArgument(name: "--prefs", description: "Get the preferences LoanShark sees", isBool: true) {(_) in
            Log.write(.info, Log.Category.application, "Requested to provide preference details, getting information and dumping it to standard out.")
            
            // Jamf URL
            print("jamfURL:" + (Preferences.sharedInstance.jssURL ?? "Not Set"))
            // Authorized Groups
            if let authGroups = Preferences.sharedInstance.authorizedGroupIDs {
                print("authorizedGroupIds:" + String(describing: authGroups))
            }
            else {
                print("authorizedGroupIds:Not Set")
            }
            // Extension Options
            if let extOpt = Preferences.sharedInstance.extensionOptions {
                print("extensionOptions:" + String(describing: extOpt))
            }
            else {
                print("extensionOptions:Not Set")
            }
            // Log Off Timer
            print("logOffTimer:" + String(describing: Preferences.sharedInstance.logoffTimer))
            // Lockout Message
            print("lockoutMessage:" + (Preferences.sharedInstance.lockoutMessage ?? "Not Set"))
            // Debugging
            print("enableDebugging:" + String(describing: Preferences.sharedInstance.enableDebugging))
            // Shared Secret
            print("sharedSecret:" + (Preferences.sharedInstance.sharedSecret ?? "Not Set"))
            // Shared Secret Auth
            print("sharedSecretAuth:" + String(describing: Preferences.sharedInstance.sharedSecretAuth))
            // Jamf Cloud
            print("jamfCloud:" + String(describing: Preferences.sharedInstance.jamfCloud))
        }
        
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // MARK: Agent Menu
        Log.write(.debug, Log.Category.application, "Building Agent Menu.")
        
        item.menu = agentMenu
        item.title = "LoanShark"
        
        Log.write(.debug, Log.Category.application, "Agent Menu built.")
        
        // MARK: Loaner Information
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
        // TODO: Switch this out for loan manager's new mech
        LoanManager.sharedInstance.addCallback {
            self.sendUserNotification()
            
            if LoanManager.sharedInstance.loanPeriod != nil {
                if LoanManager.sharedInstance.loanPeriod?.remaining ?? 0 < 0 {
                    self.loanPeriodExpired()
                }
            }
        }
        self.loanerManager.startPeriodChecker()
        
        self.argParser.parse()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func loanPeriodExpired() {
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

