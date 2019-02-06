//
//  LoanerConfigurationViewController.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/6/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa

class LoanerConfigurationViewController: NSViewController {
    
    //  MARK: Cocoa Binding Resources
    @objc var userFirst: String? {
        didSet {
            self.checkRequirements()
        }
    }
    @objc var userLast: String? {
        didSet {
            self.checkRequirements()
        }
    }
    @objc var userPhone: String? {
        didSet {
            self.checkRequirements()
        }
    }
    @objc var userEmail: String? {
        didSet {
            self.checkRequirements()
        }
    }
    
    @objc var techFirst: String? {
        didSet {
            self.checkRequirements()
        }
    }
    @objc var techLast: String? {
        didSet {
            self.checkRequirements()
        }
    }
    @objc var techPhone: String? {
        didSet {
            self.checkRequirements()
        }
    }
    @objc var techEmail: String? {
        didSet {
            self.checkRequirements()
        }
    }
    
    @objc var loanPeriod: NSNumber? {
        didSet {
            self.checkRequirements()
        }
    }
    
    @objc var requiredCompleted: Bool = false {
        didSet {
            print(requiredCompleted)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func assignDevice(_ sender: NSButton) {
        Log.write(.debug, Log.Category.view, "Recieved request to configure loaner")
        let loanee = Person(first: self.userFirst ?? "", last: self.userLast ?? "", emailAddress: self.userEmail ?? "", phoneNumber: self.userPhone ?? "")
        let tech = Person(first: self.techFirst ?? "", last: self.techLast ?? "", emailAddress: self.techEmail ?? "", phoneNumber: self.techPhone ?? "")
        
        Log.write(.info, Log.Category.view, "Requested to provide loanee of " + loanee.description + " a loaner period of " + String(describing: self.loanPeriod) + " assigned by " + tech.description)
        LoanManager.sharedInstance.setPeriod(Int(self.loanPeriod ?? 0))
        LoanManager.sharedInstance.setLoanee(loanee)
        LoanManager.sharedInstance.setTech(tech)
    }
    
    /**
     Checks to see if all the required items are filled and not empty and sets the `requiredCompleted` to true
    */
    private func checkRequirements() {
        if (
            self.userFirst?.isEmpty ?? true ||
            self.userLast?.isEmpty ?? true ||
            self.userPhone?.isEmpty ?? true ||
            self.userEmail?.isEmpty ?? true ||
            self.techFirst?.isEmpty ?? true ||
            self.techLast?.isEmpty ?? true ||
            self.techPhone?.isEmpty ?? true ||
            self.techEmail?.isEmpty ?? true ||
            self.loanPeriod == nil
        )
        {
            DispatchQueue.main.async {
                self.willChangeValue(forKey: "requiredCompleted")
                self.requiredCompleted = false
                self.didChangeValue(forKey: "requiredCompleted")
            }
        }
        else {
            DispatchQueue.main.async {
                self.willChangeValue(forKey: "requiredCompleted")
                self.requiredCompleted = true
                self.didChangeValue(forKey: "requiredCompleted")
            }
        }
    }
    
}
