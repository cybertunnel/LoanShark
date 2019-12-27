//
//  LoanerExpiredViewController.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/5/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa

class LoanerExpiredViewController: NSViewController {
    
    // MARK: Outlets
    @IBOutlet weak var message: NSTextField!
    @IBOutlet weak var timerText: NSTextField!
    @IBOutlet weak var contactName: NSTextField!
    @IBOutlet weak var contactPhone: NSTextField!
    @IBOutlet weak var contactEmail: NSTextField!
    
    // MARK: Variables
    private var timer = Preferences.sharedInstance.logoffTimer {
        didSet {
            // Minutes
            let minutes = floor(Double(self.timer) / Double(60))
            let seconds = (self.timer - Int(minutes) * 60)
            
            var timerString = ""
            if minutes >= 10 {
                timerString = "\(String(minutes))"
            } else {
                timerString = "0\(String(minutes)):"
            }
            
            if seconds >= 10 {
                timerString += String(seconds)
            } else {
                timerString += "0\(String(seconds))"
            }
            DispatchQueue.main.async {
                self.timerText.stringValue = timerString
            }
        }
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        //ValueTransformer.setValueTransformer(TimerTransformer(), forName: .timerTransformer)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.message.stringValue =  Preferences.sharedInstance.lockoutMessage ?? "Please return this loaned device."
        self.contactName.stringValue = LoanManager.sharedInstance.tech?.name ?? "Not Set"
        self.contactPhone.stringValue = LoanManager.sharedInstance.techPhone ?? "Not Set"
        contactEmail.stringValue = LoanManager.sharedInstance.techEmail ?? "Not Set"
        
        self.startTimerCountdown()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        self.view.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        self.view.layer?.cornerRadius = 10
        self.view.layer?.shadowRadius = 2
        self.view.layer?.borderWidth = 0.2
        
        self.view.layer?.isOpaque = true
    }
    
    /**
     Function to begin the countdown of the timer.
     - Note: Runs in the background and updates timer on main thread.
    */
    private func startTimerCountdown () {
        DispatchQueue.global(qos: .userInitiated).async {
            while self.timer > 0 {
                sleep(1)
                DispatchQueue.main.async {
                    self.timer -= 1
                    
                    if self.timer < 0 {
                        Log.write(.info, Log.Category.application, "Logging user off")
                        LoginWindow.logoff()
                    }
                }
            }
        }
    }
    
}
