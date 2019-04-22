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
    
    @objc var errorMessage: String? {
        willSet {
            self.willChangeValue(forKey: "errorMessage")
        }
        didSet {
            self.didChangeValue(forKey: "errorMessage")
        }
    }
    @objc var sharedSecret: String? {
        didSet {
            self.checkRequirements()
        }
    }
    @objc var isSharedSecretEnabled: Bool {
        guard let _ = Preferences.sharedInstance.sharedSecret else {
            return false
        }
        
        if !Preferences.sharedInstance.sharedSecretAuth {
            return false
        }
        return true
    }
    
    
    
    //  MARK: Variables
    public var destination: String?
    
    //  MARK: Functions
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func performAuthorization(_ sender: NSButton) {
        DispatchQueue.main.async {
            self.performingAuthorization = true
        }
        
        if self.isSharedSecretEnabled {
            DispatchQueue.global(qos: .userInitiated).async {
                //  Shared Secret Authentication Process
                let authenticator = ActivationAuthentication()
                do {
                    if try authenticator.authenticate(secret: self.sharedSecret ?? "") {
                        DispatchQueue.main.async {
                            self.performTransition()
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.errorMessage = "Sorry, you entered an invalid password."
                            self.performingAuthorization = false
                        }
                    }
                }
                catch ActivationAuthentication.AuthenticationError.NoSharedSecretStored {
                    Log.write(.error, Log.Category.view, "No shared secret is stored.")
                    DispatchQueue.main.async {
                        self.errorMessage = "There is no shared secret stored."
                        self.performingAuthorization = false
                    }
                }
                catch {
                    Log.write(.error, Log.Category.view, "Recieved unknown error from authentication.")
                }
            }
        }
        else {
            DispatchQueue.global(qos: .userInitiated).async {
                //  Jamf Pro API Authentication Method
                let authenticator = ActivationAuthentication()
                do {
                    
                    if try authenticator.authenticate(self.username ?? "", self.password ?? "") {
                        let access = try authenticator.doesHaveAccess()
                        if access {
                            DispatchQueue.main.async {
                                self.performTransition()
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                self.errorMessage = "Sorry, you do not have access to perform this action!"
                                self.performingAuthorization = false
                            }
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.errorMessage = "Unable to authenticate \(self.username ?? ""), invalid username or password."
                            self.performingAuthorization = false
                        }
                    }
                }
                catch ActivationAuthentication.AuthenticationError.UnableToAuthenticate(let message) {
                    Log.write(.error, Log.Category.view, "Recieved \(message) from authentication attempt.")
                    DispatchQueue.main.async {
                        self.errorMessage = message
                        self.performingAuthorization = false
                    }
                }
                catch {
                    Log.write(.error, Log.Category.view, "Recieved unknown error from authtentication attempt.")
                }
            }
        }
    }
    
    private func checkRequirements() {
        
        if self.isSharedSecretEnabled {
            // Non-Jamf Pro authentication check
            if self.sharedSecret?.isEmpty ?? true {
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
        else {
            //  Jamf Pro authentication check
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
    
    private func performTransition() {
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
    
}
