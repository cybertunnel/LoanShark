//
//  AuthenticationViewController.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/6/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa

class AuthenticationViewController: NSViewController {

    // MARK: Outlets
    @IBOutlet weak var usernameField: NSTextField!
    @IBOutlet weak var passwordField: NSTextField!
    @IBOutlet weak var passphraseField: NSTextField!
    @IBOutlet weak var errorMessage: NSTextField!
    @IBOutlet weak var jamfAuthView: NSView!
    @IBOutlet weak var passphraseView: NSView!
    @IBOutlet weak var authenticateButton: NSButton!
    @IBOutlet weak var authenticationIndicator: NSProgressIndicator!
    
    var isSharedSecretEnabled: Bool {
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
        
        if Preferences.sharedInstance.sharedSecretAuth {
            self.jamfAuthView.isHidden = true
            self.passphraseView.isHidden = false
        } else {
            self.jamfAuthView.isHidden = false
            self.passphraseView.isHidden = true
        }
    }
    
    private func setEnabled(to enabled: Bool) {
        
        self.authenticationIndicator.isHidden = enabled
        self.authenticationIndicator.startAnimation(self)
        let jamfViews: Array <NSTextField> = [
            self.usernameField,
            self.passwordField
        ]
        
        let passphraseViews: Array <NSTextField> = [
            self.passphraseField
        ]
        
        if Preferences.sharedInstance.sharedSecretAuth {
            for view in passphraseViews {
                view.isEnabled = enabled
            }
        } else {
            for view in jamfViews {
                view.isEnabled = enabled
            }
        }
    }
    
    @IBAction func performAuthorization(_ sender: NSButton) {
        DispatchQueue.main.async {
            sender.isEnabled = false
            self.setEnabled(to: false)
        }
        
        if self.isSharedSecretEnabled {
            DispatchQueue.global(qos: .userInitiated).async {
                //  Shared Secret Authentication Process
                let authenticator = ActivationAuthentication()
                do {
                    if try authenticator.authenticate(secret: self.passphraseField.stringValue) {
                        DispatchQueue.main.async {
                            self.performTransition()
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.errorMessage.stringValue = "Sorry, you entered an invalid password."
                            self.errorMessage.isHidden = false
                            sender.isEnabled = true
                            self.setEnabled(to: true)
                        }
                    }
                }
                catch ActivationAuthentication.AuthenticationError.NoSharedSecretStored {
                    Log.write(.error, Log.Category.view, "No shared secret is stored.")
                    DispatchQueue.main.async {
                        self.errorMessage.stringValue = "There is no shared secret stored."
                        self.errorMessage.isHidden = false
                        self.setEnabled(to: true)
                        sender.isEnabled = true
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
                var username = ""
                var password = ""
                DispatchQueue.main.sync {
                    username = self.usernameField.stringValue
                    password = self.passwordField.stringValue
                }
                do {
                    if try authenticator.authenticate(username, password) {
                        let access = try authenticator.doesHaveAccess()
                        if access {
                            DispatchQueue.main.async {
                                Log.write(.debug, Log.Category.authenticator, "Attempting to perform transition.")
                                self.performTransition()
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                self.errorMessage.stringValue = "Sorry, you do not have access to perform this action!"
                                self.errorMessage.isHidden = false
                                self.setEnabled(to: true)
                            }
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.errorMessage.stringValue = "Unable to authenticate \(self.usernameField.stringValue), invalid username or password."
                            self.errorMessage.isHidden = false
                            self.setEnabled(to: true)
                            sender.isEnabled = true
                        }
                    }
                }
                catch ActivationAuthentication.AuthenticationError.UnableToAuthenticate(let message) {
                    Log.write(.error, Log.Category.view, "Recieved \(message) from authentication attempt.")
                    DispatchQueue.main.async {
                        self.errorMessage.stringValue = message
                        self.errorMessage.isHidden = false
                        sender.isEnabled = true
                        self.setEnabled(to: true)
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
            if !self.passphraseField.stringValue.isEmpty {
                self.authenticateButton.isEnabled = true
            } else {
                self.authenticateButton.isEnabled = false
            }
        }
        else {
            //  Jamf Pro authentication check
            if !self.usernameField.stringValue.isEmpty && !self.passwordField.stringValue.isEmpty {
                self.authenticateButton.isEnabled = true
            } else {
                self.authenticateButton.isEnabled = false
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
