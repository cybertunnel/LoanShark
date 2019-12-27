//
//  ExtensionRequestViewController.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/6/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa

class ExtensionRequestViewController: NSViewController {
    
    
    //  MARK:   IBOutlets
    @IBOutlet weak var requestOptions: NSPopUpButton!
    @IBOutlet weak var justificationField: NSTextField!
    @IBOutlet weak var requestButton: NSButton!
    @IBOutlet weak var errorMessage: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.requestOptions.removeAllItems()
        guard let options = Preferences.sharedInstance.extensionOptions else {
            self.requestOptions.addItem(withTitle: "Not Set")
            return
        }
        
        self.requestOptions.addItems(withTitles: options)
        
        // Do view setup here.
    }
    
    @IBAction func sendRequest(_ sender: NSButton) {
        
        let justification = self.justificationField.stringValue
        
        if justification.lengthOfBytes(using: .utf8) < 10 {
            self.errorMessage.stringValue = "Justification is not valid, please enter a valid justification."
            self.errorMessage.isHidden = false
            return
        }
        
        if Preferences.sharedInstance.useGmail {
            
            let urlString = "https://mail.google.com/mail/u/0/?view=cm&fs=1&to=\(LoanManager.sharedInstance.techEmail)&su=\("Extension Request - Current End Date of \(LoanManager.sharedInstance.loanPeriod?.end.toString(format: "MM/dd/yyyy") ?? "UNKNOWN")")&body=\("Extension request is being made of \(self.requestOptions.titleOfSelectedItem ?? "UNKNOWN")\n With justification of \(justification)")"
            let url = URL(string: urlString)
            NSWorkspace.shared.open(url!)
          
            self.view.window?.close()
        }
        else {
            let body = "Extension request is being made of \(self.requestOptions.titleOfSelectedItem ?? "UNKNOWN")\n With justification of \(justification)"
            let shareItems = [body]
            
            let service = NSSharingService(named: .composeEmail)
            
            
            guard let recipient = LoanManager.sharedInstance.tech?.emailAddr else {
                self.errorMessage.stringValue = "Tech information is not set, unable to find who to request extension from."
                self.errorMessage.isHidden = false
                return
            }
            
            service?.recipients = [recipient]
            service?.subject = "Extension Request - Current End Date of \(LoanManager.sharedInstance.loanPeriod?.end.toString(format: "MM/dd/yyyy") ?? "UNKNOWN")"
            service?.perform(withItems: shareItems)
            
            self.view.window?.close()
        }
    }
}
