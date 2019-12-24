//
//  LoanerConfigurationViewController.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/6/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa

class LoanerConfigurationViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func assignDevice(_ sender: NSButton) {
        Log.write(.debug, Log.Category.view, "Recieved request to configure loaner")
        let loanee = Person(first: self.userFirst ?? "", last: self.userLast ?? "", emailAddress: self.userEmail ?? "", phoneNumber: self.userPhone ?? "")
        let tech = Person(first: self.techFirst ?? "", last: self.techLast ?? "", emailAddress: self.techEmail ?? "", phoneNumber: self.techPhone ?? "")
        
        Log.write(.info, Log.Category.view, "Requested to provide loanee of " + loanee.description + " a loaner period of " + String(describing: self.loanPeriod) + " assigned by " + tech.description)
        LoanManager.sharedInstance.setLoanee(loanee)
        LoanManager.sharedInstance.setTech(tech)
        LoanManager.sharedInstance.setPeriod(Int(truncating: self.loanPeriod ?? 0))
        
        self.view.window?.close()
    }
    
    /**
     Checks to see if all the required items are filled and not empty and sets the `requiredCompleted` to true
    */
    private func checkRequirements() {
        
    }
    
}
