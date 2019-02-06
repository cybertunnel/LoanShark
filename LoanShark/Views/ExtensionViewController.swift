//
//  ExtensionViewController.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/6/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa

class ExtensionViewController: NSViewController {
    
    @objc var extensionAmount: NSNumber? {
        didSet {
            self.checkRequirements()
        }
    }
    @objc var extenderEmailAddr: String? {
        didSet {
            self.checkRequirements()
        }
    }
    
    @objc var requirementsMet: Bool = false {
        willSet {
            self.willChangeValue(forKey: "requirementsMet")
        }
        didSet {
            self.didChangeValue(forKey: "requirementsMet")
        }
    }
    
    
    //  MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    private func checkRequirements() {
        if self.extensionAmount == 0 || self.extensionAmount == nil || self.extenderEmailAddr?.isEmpty ?? true{
            self.requirementsMet = false
        }
        else {
            self.requirementsMet = true
        }
    }
    
    //  MARK: IB Actions
    @IBAction func extend(_ sender: NSButton) {
        self.view.window?.close()
    }
    
}
