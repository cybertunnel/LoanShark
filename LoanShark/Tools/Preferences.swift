//
//  Preferences.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/5/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Foundation

/**
 Preferences of the application
 */
class Preferences {
    
    
    //  MARK: Variables
    
    static let sharedInstance = Preferences() //    Singleton
    internal let userDefaults: UserDefaults
    
    public var startDate: Date? {
        get {
            return self.userDefaults.date(forKey: "startDate")
        }
        set {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            guard let newDate = newValue else {
                return
            }
            let prefValue = formatter.string(from: newDate)
            self.userDefaults.set(prefValue, forKey: "startDate")
            self.userDefaults.synchronize()
        }
    }
    
    public var endDate: Date? {
        get {
            return self.userDefaults.date(forKey: "endDate")
        }
        set {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            guard let newDate = newValue else {
                return
            }
            let prefValue = formatter.string(from: newDate)
            self.userDefaults.set(prefValue, forKey: "endDate")
            self.userDefaults.synchronize()
        }
    }
    
    public var loaneeDetails: Person? {
        get {
            return self.userDefaults.person(forKey: "loanee")
        }
        set(newValue) {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            self.userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: newValue as Any), forKey: "loanee")
            self.userDefaults.synchronize()
        }
    }
    
    public var administratorDetails: Person? {
        get {
            return self.userDefaults.person(forKey: "administrator")
        }
        set {
            self.userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: newValue as Any), forKey: "administrator")
            self.userDefaults.synchronize()
        }
    }
    
    public var contactDetails: Person? {
        get {
            return self.userDefaults.person(forKey: "contact")
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue as Any)
            self.userDefaults.set(data, forKey: "contact")
            self.userDefaults.synchronize()
        }
    }
    
    public var runScriptOnChange: String? {
        get {
            return self.userDefaults.string(forKey: "scriptOnChange")
        }
    }
    
    public var runScriptOnSet: String? {
        get {
            return self.userDefaults.string(forKey: "scriptOnSet")
        }
    }
    
    public var runScriptOnExpire: String? {
        get {
            return self.userDefaults.string(forKey: "scriptOnExpire")
        }
    }
    
    public var logoffTimer: Int {
        get {
            let timerValue = self.userDefaults.integer(forKey: "logoffTimer")
            if timerValue == 0 {
                return 120
            }
            else {
                return timerValue
            }
        }
    }
    
    public var lockoutMessage: String? {
        get {
            return self.userDefaults.string(forKey: "lockoutMessage")
        }
    }
    
    public var jssURL: String? {
        get {
            return self.userDefaults.string(forKey: "jamfURL")
        }
    }
    
    public var authorizedGroupIDs: Array<Int>? {
        get {
            return self.userDefaults.array(forKey: "authorizedGroupIDs") as? Array<Int>
        }
    }
    
    public var extensionOptions: Array<String>? {
        get {
            return self.userDefaults.array(forKey: "extensionOptions") as? Array<String>
        }
    }
    
    public var enableDebugging: Bool {
        get {
            return self.userDefaults.bool(forKey: "enableDebugging")
        }
    }
    
    public var sharedSecret: String? {
        get {
            return self.userDefaults.string(forKey: "sharedSecret")
        }
    }
    
    //MARK: Initializers
    
    init(nsUserDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = nsUserDefaults
    }
    
    init(defaults: UserDefaults) {
        self.userDefaults = defaults
    }
}
