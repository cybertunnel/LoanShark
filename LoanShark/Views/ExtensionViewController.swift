//
//  ExtensionViewController.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/6/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa

class ExtensionViewController: NSViewController {
    
    //  MARK: Outlets
    @IBOutlet weak var extensionAmount: NSTextField!
    @IBOutlet weak var extensionUser: NSTextField!
    @IBOutlet weak var errorMessage: NSTextField!
    @IBOutlet weak var extensionButton: NSButton!
    
    
    //  MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .background).async {
            while true {
                DispatchQueue.main.async {
                    self.checkRequirements()
                }
                sleep(1)
            }
        }
        // Do view setup here.
    }
    
    private func checkRequirements() {
        if self.extensionAmount.integerValue == 0 || self.extensionUser.stringValue.isEmpty {
            self.extensionButton.isEnabled = false
        }
        else {
            self.extensionButton.isEnabled = true
        }
    }
    
    //  MARK: IB Actions
    @IBAction func extend(_ sender: NSButton) {
        sender.isEnabled = false
        let extend = self.extensionAmount.integerValue
        
        if extend < 0 {
            self.errorMessage.stringValue = "Extension amount is in the negative, must be positive."
            self.errorMessage.isHidden = false
            sender.isEnabled = true
            return
        } else if extend == 0 {
            self.errorMessage.stringValue = "Extension amount must be greater than 0."
            self.errorMessage.isHidden = false
            sender.isEnabled = true
            return
        }
        do {
            try LoanManager.sharedInstance.extend(extensionOf: extend)
            self.view.window?.close()
        } catch {
            self.errorMessage.stringValue = "Error was thrown"
            self.errorMessage.isHidden = false
            sender.isEnabled = false
            return
        }
    }
    
}
