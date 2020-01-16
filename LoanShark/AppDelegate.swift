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
    let loanerManager = LoanManager.sharedInstance
    let enableDebugging = Preferences.sharedInstance.enableDebugging
    
    //  Don't Use
    private var lockoutWindow: LockoutWindowController!
    private var storyboard: NSStoryboard {
        return NSStoryboard(name: "Main", bundle: nil)
    }
    
    // MARK: Arguments
    let arguements = [
        /// Sets the loaner period to expired
        Argument(
            name: "--set-expired",
            description: "Set loaner period to expired.",
            isBool: true,
            callback: { (_) in
                Log.write(.info, Log.Category.application, "Set expiration argument sent, setting loaner period to expired.")
                print("Setting Loan Period to expired!")
                LoanManager.sharedInstance.setExpired()
                exit(0)
            }
        ),
        
        /// Extends the loaner period
        Argument(
            name: "--extend",
            description: "Extend loaner by set number of days.",
            isBool: false,
            callback: { (value) in
                Log.write(.info, Log.Category.application, "Loaner extension argument passed, attempting to extend loaner")
                
                guard let passcode = value["--passcode"] else {
                    Log.write(.fault, Log.Category.application, "--passcode was not passed, unable to authenticate.")
                    print("Missing --passcode argument.")
                    exit(1)
                }
                
                guard let sharedSecret = Preferences.sharedInstance.sharedSecret else {
                    Log.write(.fault, Log.Category.application, "Shared secret not configured, please ensure this is configured before attempting to extend loaner period via. Command Line")
                    
                    print("Missing Shared Secret in preferences for --passcode or --extend to work properly.")
                    exit(1)
                }
                
                if passcode.sha256().lowercased() == sharedSecret.lowercased() {
                    guard let length_string = value["--extend"] else {
                        Log.write(.error, Log.Category.application, "Extension amount was not provided!.")
                        exit(1)
                    }
                    
                    guard let length = Int(length_string) else {
                        Log.write(.error, Log.Category.application,"Unable to parse extension amount from provided \(length_string) length.")
                        exit(1)
                    }
                    do {
                        try LoanManager.sharedInstance.extend(extensionOf: length)
                    }
                    catch {
                        Log.write(.fault, Log.Category.application, "Error occurred while extending loan period.")
                        exit(1)
                    }
                    
                    print("Successfully extended the loaner by \(length_string) days!")
                    exit(0)
                } else {
                    Log.write(.error, Log.Category.application, "Passcode provided does not match stored passcode, unable to properly authenticate.")
                    exit(1)
                }
            }
        ),
        
        /// Passcode used for assignment, and extension
        Argument(
            name: "--passcode",
            description: "Passcode to properly authenticate you.",
            isBool: false,
            callback: { _ in
                return
            }
        ),
        
        //  Gets the current status of the loan.
        Argument(
            name: "--status",
            description: "Get the loaner period status",
            isBool: true,
            callback: { (_) in
                Log.write(.info, Log.Category.application, "Requested to provide loaner period status")
                print(LoanManager.sharedInstance.loanStatus.rawValue)
                NSApp.terminate(self)
                
            }
        ),
        
        /// Gets the current loanee details
        Argument(
            name: "--loanee-details",
            description: "Get the loanee details",
            isBool: true,
            callback: { (_) in
                Log.write(.info, Log.Category.application, "Requested to give loanee details, getting and providing loanee information")
                print(LoanManager.sharedInstance.loanee?.description ?? "No Information to Provide")
                NSApp.terminate(self)
            }
        ),
        
        /// DEBUG: Preferences
        Argument(
            name: "--prefs",
            description: "Get the preferences LoanShark sees.",
            isBool: true,
            callback: { (_) in
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
        )
    ]
    
    
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
        
        for argument in self.arguements {
            argParser.addArgument(
                name: argument.name,
                description: argument.description,
                isBool: argument.isBool,
                callback: argument.callback
            )
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // MARK: Agent Menu
        Log.write(.debug, Log.Category.application, "Building Agent Menu.")
        
        item.menu = agentMenu
        item.title = "LoanShark"
        LoanManager.sharedInstance.addCallback {
            DispatchQueue.main.async {
                switch LoanManager.sharedInstance.loanStatus {
                case .active:
                    self.item.image = NSImage(named: NSImage.statusAvailableName)
                case .warning:
                    self.item.image = NSImage(named: NSImage.statusPartiallyAvailableName)
                case .critical:
                    self.item.image = NSImage(named: NSImage.statusUnavailableName)
                case .notSet:
                    self.item.image = NSImage(named: NSImage.statusNoneName)
                default:
                    self.item.image = NSImage(named: NSImage.statusNoneName)
                }
            }
        }
        
        Log.write(.debug, Log.Category.application, "Agent Menu built.")
        
        // MARK: Loaner Information
        Log.write(.info, Log.Category.application, "Checking loaner information")
        if let startDate = Preferences.sharedInstance.startDate, let endDate = Preferences.sharedInstance.endDate {
            Log.write(.debug, Log.Category.application, "Start Date: \(startDate.toString(format: "MM/dd/yyyy")) ; End DateL \(endDate.toString(format: "MM/dd/yyyy"))")
            let period = Loan(startDate: startDate, endDate: endDate)
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
        
        self.argParser.parse()
    }

    
    func loanPeriodExpired() {
        Log.write(.info, Log.Category.application, "Loan period expired, displaying lockout message")
        DispatchQueue.main.async {
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

