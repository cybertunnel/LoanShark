//
//  ExtensionRequestViewController.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/6/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa

class ExtensionRequestViewController: NSViewController {
    
    
    //  MARK: Cocoa Binding Resources
    
    /// Options for the user to select.
    @objc var options = ["Option 1", "Option 2"]
    @objc var justification: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func sendRequest(_ sender: NSButton) {
        
    }
}
