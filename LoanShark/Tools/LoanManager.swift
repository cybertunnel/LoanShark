//
//  LoanManager.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/5/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Foundation

@objc class LoanManager: NSObject {
    
    
    //  MARK: Enumerations
    
    
    /**
     Status of the loaner that the manager knows about.
    */
    @objc enum Status: UInt {
        case active, warning, critical, expired, notSet
        func toString() -> String {
            switch self {
            case .active:
                return "Active"
            case .warning:
                return "Warning"
            case .critical:
                return "Critical"
            case .expired:
                return "Expired"
            case .notSet:
                return "Not Set"
            }
        }
    }
    
    
    //  MARK: Variables
    
    
    //  Current status of the loaning period
    @objc var loanStatus: Status {
        get {
            
            /// Checks if a loan period has been set.
            guard let period = self.loanPeriod else {
                Log.write(.error, Log.Category.loanManager, "Loan period has not been set yet.")
                return .notSet
            }
            
            /// Checking how many days remaining
            switch period.remaining {
            case _ where period.remaining >= 15:
                return .active
            case _ where period.remaining >= 5:
                return .warning
            case _ where period.remaining >= 0:
                return .critical
            default:
                return .expired
            }
        }
    }
    
    @objc var loanee: Person?
    @objc var tech: Person?
    
    @objc var loaneeName: String? {
        get {
            guard let name = self.loanee?.name else {
                return nil
            }
            return "Assigned User: \(name)"
        }
    }
    
    @objc var loaneePhone: String? {
        get {
            guard let phone = self.loanee?.phoneNum else {
                return nil
            }
            return "Phone Number: \(phone)"
        }
    }
    
    @objc var loaneeEmail: String? {
        get {
            guard let email = self.loanee?.emailAddr else {
                return nil
            }
            return "Email: \(email)"
        }
    }
    
    @objc var loanPeriod: LoanPeriod? {
        willSet {
            self.willChangeValue(forKey: "loanPeriod")
            self.willChangeValue(forKey: "loanStatus")
        }
        didSet {
            self.didChangeValue(forKey: "loanPeriod")
            self.didChangeValue(forKey: "loanStatus")
        }
    }
    
    static let sharedInstance = LoanManager()
    
    
    
    
    //  MARK: Functions
    
    
    /**
     Sets the period of the loaner.
     - Parameter length: How long the loaner period will be as Int
    */
    func setPeriod(_ length: Int) {
        Log.write(.debug, Log.Category.loanManager, "Recieved request to begin a loaner period of " + String(describing: length))
        Log.write(.info, Log.Category.loanManager, "Setting loaner period of " + String(describing: length) + " days.")
        
        let currentDate = Date()
        Log.write(.debug, Log.Category.loanManager, "Recieved a system date of " + String(describing: currentDate))
        Preferences.sharedInstance.startDate = currentDate
        
        guard let endDate = Calendar.current.date(byAdding: .day, value: length,  to: currentDate) else {
            Log.write(.fault, Log.Category.loanManager, "Was unable to calculate end date!")
            return
        }
        Log.write(.debug, Log.Category.loanManager, "Calculated an end date of " + String(describing: endDate))
        Preferences.sharedInstance.endDate = endDate
        
        self.loanPeriod = LoanPeriod(startDate: currentDate, endDate: endDate)
        Log.write(.info, Log.Category.loanManager, "Successfully set loaning period ending on " + String(describing: endDate))
        Log.write(.debug, Log.Category.loanManager, "Alerting whole application loaner period has been set.")
        NotificationCenter.default.post(name: NSNotification.Name.loanerPeriodSet, object: nil)
    }
    
    /**
     Sets the loanee information for the loaner.
     - Parameter person: The user who the loaner is assigned to as Person Object.
    */
    func setLoanee(_ person: Person) {
        Log.write(.debug, Log.Category.loanManager, "Setting the loanee of " + person.description)
        self.loanee = person
        
        
        /// Checks if the loanee information needs updating.
        Log.write(.debug, Log.Category.loanManager, "Checking if preferences match the provided loanee information")
        if let loanee = Preferences.sharedInstance.loaneeDetails {
            if (
                loanee.first == person.first &&
                loanee.last == person.last &&
                loanee.emailAddr == person.emailAddr &&
                loanee.phoneNum == person.phoneNum
                )
            {
                Log.write(.debug, Log.Category.loanManager, "Loanee details are the same, no need to update.")
            }
            else {
                Log.write(.info, Log.Category.loanManager, "Updating loanee information from " + loanee.description + " to " + person.description)
                Preferences.sharedInstance.loaneeDetails = person
            }
        }
        else {
            Log.write(.debug, Log.Category.loanManager, "Loanee information was never set, setting details now.")
            Preferences.sharedInstance.loaneeDetails = person
        }
    }
    
    
    /**
     Sets the tech information for the loaner.
     - Parameter person: The user who assigned the loaner as Person Object.
    */
    func setTech(_ person: Person) {
        Log.write(.debug, Log.Category.loanManager, "Setting the tech who assigned loaner to " + person.description)
        self.tech = person
        
        /// Checks if the tech information needs updating.
        Log.write(.debug, Log.Category.loanManager, "Checking if preferences match the provided tech information")
        if let tech = Preferences.sharedInstance.contactDetails {
            if (
                tech.first == person.first &&
                    tech.last == person.last &&
                    tech.emailAddr == person.emailAddr &&
                    tech.phoneNum == person.phoneNum
                )
            {
                Log.write(.debug, Log.Category.loanManager, "Tech details are the same, no need to update.")
            }
            else {
                Log.write(.info, Log.Category.loanManager, "Updating Tech information from " + tech.description + " to " + person.description)
                Preferences.sharedInstance.contactDetails = person
            }
        }
        else {
            Log.write(.debug, Log.Category.loanManager, "Tech information was never set, setting details now.")
            Preferences.sharedInstance.contactDetails = person
        }
    }
    
    
    /**
     Extends the loaner by the provided amount of time in days.
     - Parameter extensionOf: Number of days the loaner will be extended for.
    */
    func extend(extensionOf amount: Int) {
        Log.write(.info, Log.Category.loanManager, "Recieved a request to extend loaner by " + String(describing: amount) + " days.")
        
    }
}
