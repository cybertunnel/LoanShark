//
//  AuthenticationViewController.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/6/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa

class AuthenticationViewController: NSViewController {

    //  MARK: Cocoa Binding Resources
    @objc var username: String? {
        didSet {
            self.checkRequirements()
        }
    }
    @objc var password: String? {
        didSet {
            self.checkRequirements()
        }
    }
    @objc var performingAuthorization: Bool = false {
        willSet {
            self.willChangeValue(forKey: "performingAuthorization")
        }
        didSet {
            self.didChangeValue(forKey: "performingAuthorization")
        }
    }
    
    @objc var requirementsCompleted: Bool = false
    
    
    //  MARK: Variables
    public var destination: String?
    
    //  MARK: Functions
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func performAuthorization(_ sender: NSButton) {
        self.performingAuthorization = true
        
        let authenticator = ActivationAuthentication()
        do {
            try authenticator.authenticate(self.username ?? "", self.password ?? "")
        }
        catch ActivationAuthentication.AuthenticationError.UnableToAuthenticate(let message) {
            Log.write(.error, Log.Category.view, "Recieved \(message) from authentication attempt.")
        }
        catch {
            Log.write(.error, Log.Category.view, "Recieved unknown error from authtentication attempt.")
        }
        
        if let dest = self.destination {
            if dest == "configure" {
                self.view.window?.close()
                self.performSegue(withIdentifier: "toConfiguration", sender: self)
            }
            else if dest == "extend" {
                self.view.window?.close()
                self.performSegue(withIdentifier: "toExtension", sender: self)
            }
        }
    }
    
    private func checkRequirements() {
        if self.username?.isEmpty ?? true || self.password?.isEmpty ?? true {
            self.willChangeValue(forKey: "requirementsCompleted")
            self.requirementsCompleted = false
            self.didChangeValue(forKey: "requirementsCompleted")
        }
        else {
            self.willChangeValue(forKey: "requirementsCompleted")
            self.requirementsCompleted = true
            self.didChangeValue(forKey: "requirementsCompleted")
        }
    }
    
}
