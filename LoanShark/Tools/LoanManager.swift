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
    
    enum ExtensionError: Error {
        case LoanerPeriodIsNull
    }
    
    
    //  MARK: Variables
    
    
    //  Current status of the loaning period
    @objc var loanStatus: Status {
        get {
            Log.write(.info, Log.Category.loanManager, "Loan Status requested")
            /// Checks if a loan period has been set.
            guard let period = self.loanPeriod else {
                Log.write(.error, Log.Category.loanManager, "Loan period has not been set yet.")
                return .notSet
            }
            
            Log.write(.debug, Log.Category.loanManager, "period set \(period.description)")
            
            /// Checking how many days remaining
            Log.write(.debug, Log.Category.loanManager, "Checking time remaining")
            switch period.remaining {
            case _ where period.remaining >= 15:
                Log.write(.debug, Log.Category.loanManager, "15 days or more remaining on loaning period")
                return .active
            case _ where period.remaining >= 5:
                Log.write(.debug, Log.Category.loanManager, "Between 5 and 14 days remaining on loaning period")
                return .warning
            case _ where period.remaining >= 0:
                Log.write(.debug, Log.Category.loanManager, "Between 0 and 4 days remaining on loaning period")
                return .critical
            default:
                Log.write(.debug, Log.Category.loanManager, "Less than 0 days remaining on loaning period")
                NotificationCenter.default.post(name: NSNotification.Name.loanerPeriodExpired, object: nil)
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
    
    @objc var techEmail: String? {
        get {
            guard let email = self.tech?.emailAddr else {
                return nil
            }
            return "Email: \(email)"
        }
    }
    
    @objc var techPhone: String? {
        get {
            guard let phone = self.tech?.phoneNum else {
                return nil
            }
            return "Phone Number: \(phone)"
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
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name.loanerPeriodSet, object: nil)
        }
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
    func extend(extensionOf amount: Int) throws {
        Log.write(.info, Log.Category.loanManager, "Recieved a request to extend loaner by " + String(describing: amount) + " days.")
        
        guard let period = self.loanPeriod else {
            throw ExtensionError.LoanerPeriodIsNull
        }
        
        let totalDays = period.remaining + amount
        guard let endDate = Calendar.current.date(byAdding: .day, value: totalDays, to: Date()) else {
            return
        }
        let newPeriod = LoanPeriod(startDate: period.start, endDate: endDate)
        
        Preferences.sharedInstance.endDate = endDate
        self.loanPeriod = newPeriod
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name.loanerPeriodChanged, object: nil)
        }
    }
    
    /**
     Checks every 30 minutes for a period change.
    */
    func checkPeriod(_ previousValue: Int) -> Int {
        Log.write(.debug, Log.Category.loanManager, "Checking period using previous value of \(previousValue.description)")
        if previousValue != self.loanPeriod?.remaining ?? 0 {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name.loanerPeriodChanged, object: nil)
            }
            return self.loanPeriod?.remaining ?? 0
        }
        else {
            return previousValue
        }
    }
    
    /**
     Starts checking the loaning period remaining and alerts the application of a change.
    */
    func startPeriodChecker() {
        DispatchQueue.global(qos: .background).async {
            var currentRemaining = 0
            while true {
                currentRemaining = self.checkPeriod(currentRemaining)
                sleep(6000)
            }
        }
    }
}
