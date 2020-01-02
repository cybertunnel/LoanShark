//
//  LoanerConfigurationViewController.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/6/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa

class LoanerConfigurationViewController: NSViewController {
    
    // MARK: Outlets
    @IBOutlet weak var periodLength: NSTextField!
    @IBOutlet weak var userFirst: NSTextField!
    @IBOutlet weak var userLast: NSTextField!
    @IBOutlet weak var userPhone: NSTextField!
    @IBOutlet weak var userEmail: NSTextField!
    @IBOutlet weak var techFirst: NSTextField!
    @IBOutlet weak var techLast: NSTextField!
    @IBOutlet weak var techPhone: NSTextField!
    @IBOutlet weak var techEmail: NSTextField!
    @IBOutlet weak var assignButton: NSButton!
    @IBOutlet weak var lengthModifier: NSPopUpButton!
    
    // MARK: Variables
    public var userObj: Person? {
        didSet {
            guard let user = self.userObj else {
                Log.write(.error, Log.Category.view, "User object not assigned!")
                return
            }
            
            self.techFirst.stringValue = user.first
            self.techLast.stringValue = user.last
            self.techEmail.stringValue = user.emailAddr
            self.techPhone.stringValue = user.phoneNum
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        DispatchQueue.global(qos: .background).async {
            while true {
                DispatchQueue.main.async {
                    self.checkRequirements()
                }
                sleep(1)
            }
        }
    }
    
    @IBAction func assignDevice(_ sender: NSButton) {
        Log.write(.debug, Log.Category.view, "Recieved request to configure loaner")
        let loanee = Person(first: self.userFirst.stringValue,
                            last: self.userLast.stringValue,
                            emailAddress: self.userEmail.stringValue,
                            phoneNumber: self.userPhone.stringValue)
        
        let tech = Person(first: self.techFirst.stringValue,
                          last: self.techLast.stringValue,
                          emailAddress: self.techEmail.stringValue,
                          phoneNumber: self.techPhone.stringValue)
        
        Log.write(.info, Log.Category.view, "Requested to provide loanee of " + loanee.description + " a loaner period of " + String(describing: self.periodLength.intValue) + " assigned by " + tech.description)
        LoanManager.sharedInstance.setLoanee(loanee)
        LoanManager.sharedInstance.setTech(tech)
        var length = self.periodLength.integerValue
        switch self.lengthModifier.titleOfSelectedItem {
        case "Day(s)":
            break
        case "Week(s)":
            length *= 7
        case "Month(s)":
            length *= 30
        default:
            break
        }
        LoanManager.sharedInstance.setPeriod(length)
        
        self.view.window?.close()
    }
    
    /**
     Checks to see if all the required items are filled and not empty and sets the `requiredCompleted` to true
    */
    private func checkRequirements() {
        if (self.techPhone.stringValue.isEmpty ||
            self.techFirst.stringValue.isEmpty ||
            self.techLast.stringValue.isEmpty ||
            self.techEmail.stringValue.isEmpty ||
            self.userFirst.stringValue.isEmpty ||
            self.userLast.stringValue.isEmpty ||
            self.userEmail.stringValue.isEmpty ||
            self.userPhone.stringValue.isEmpty ||
            self.periodLength.integerValue == 0) {
            self.assignButton.isEnabled = false
        } else {
            self.assignButton.isEnabled = true
        }
    }
    
}
