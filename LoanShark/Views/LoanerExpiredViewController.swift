//
//  LoanerExpiredViewController.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/5/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa

class LoanerExpiredViewController: NSViewController {
    
    
    //  MARK: Variables
    
    /**
     The timer value from preferences
    */
    var timer = Preferences.sharedInstance.logoffTimer {
        willSet {
            self.willChangeValue(forKey: "timerString")
        }
        didSet {
            self.didChangeValue(forKey: "timerString")
        }
    }
    
    //  MARK: Cocoa Binding Resources
    
    
    /**
     String that the UI uses to display to the user.
    */
    @objc var timerString: String {
        get {
            return String(describing: self.timer)
        }
    }
    
    /**
     The contact's full name pulled from the Preferences class.
    */
    @objc var contactName: String? {
        get {
            return Preferences.sharedInstance.contactDetails?.name
        }
    }
    
    /**
     The contact's phone number pulled from the Preferences class.
    */
    @objc var contactPhone: String? {
        get {
            return Preferences.sharedInstance.contactDetails?.phoneNum
        }
    }
    
    /**
     The contact's email address pulled from the Preferences class.
    */
    @objc var contactEmail: String? {
        get {
            return Preferences.sharedInstance.contactDetails?.emailAddr
        }
    }
    
    /**
     The lockout message that is displayed to the end user. This is pulled from the Preferences class.
    */
    @objc var lockoutMessage: String? {
        get {
            return Preferences.sharedInstance.lockoutMessage
        }
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        //ValueTransformer.setValueTransformer(TimerTransformer(), forName: .timerTransformer)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.startTimerCountdown()
    }
    
    /**
     Function to begin the countdown of the timer.
     - Note: Runs in the background and updates timer on main thread.
    */
    private func startTimerCountdown () {
        DispatchQueue(label: "TimerCountdown", qos: DispatchQoS.userInitiated, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.workItem, target: nil).async {
            while true {
                sleep(1)
                DispatchQueue.main.async {
                    self.timer -= 1
                }
            }
        }
    }
    
}
