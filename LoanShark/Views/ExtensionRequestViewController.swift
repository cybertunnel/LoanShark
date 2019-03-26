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
    
    /// Options for the user to select.
    @objc var options = Preferences.sharedInstance.extensionOptions ?? ["None Set"]
    @objc var justification: String?
    
    @objc var errMsg: String? {
        willSet {
            self.willChangeValue(forKey: "errMsg")
        }
        didSet {
            self.didChangeValue(forKey: "errMsg")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
    }
    
    @IBAction func sendRequest(_ sender: NSButton) {
        
        guard let justification = self.justification else {
            self.errMsg = "Justification not provided."
            return
        }
        
        if justification.lengthOfBytes(using: .utf8) < 10 {
            self.errMsg = "Justification is not valid, please enter a valid justification."
            return
        }
        
        let body = "Extension request is being made of \(self.requestOptions.titleOfSelectedItem ?? "UNKNOWN")"
        let shareItems = [body]
        
        let service = NSSharingService(named: .composeEmail)
        
        guard let recipient = LoanManager.sharedInstance.tech?.emailAddr else {
            self.errMsg = "Tech information is not set, unable to find who to request extension from."
            return
        }
        
        service?.recipients = [recipient]
        service?.subject = "Extension Request - Current End Date of \(LoanManager.sharedInstance.loanPeriod?.end.toString(format: "MM/dd/yyyy") ?? "UNKNOWN")"
        service?.perform(withItems: shareItems)
        
        self.view.window?.close()
    }
}
