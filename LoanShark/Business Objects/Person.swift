//
//  Person.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/5/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Foundation

/**
 Object used while assigning device, and announcing who to contact.
 */
class Person: NSObject, NSCoding {
    
    //  MARK: Variables
    let first: String
    let last: String
    var name: String {
        get {
            return "\(first) \(last)"
        }
    }
    let emailAddr: String
    let phoneNum: String
    
    override var description: String {
        return "Person with name of \(name) with the phone number of \(phoneNum) and an email address of \(emailAddr)."
    }
    
    //  MARK: Initializers
    /**
     - parameters:
        - first: First name of the person.
        - last: Last name of the person.
        - emailAddress: Email address of the person.
        - phoneNumber: Preferred phone number of the person.
     */
    init(first fname: String, last lname: String, emailAddress emailAddr: String, phoneNumber phNum: String) {
        self.first = fname
        self.last = lname
        self.emailAddr = emailAddr
        self.phoneNum = phNum
    }
    
    //  Decoder for when Person is getting read from preferences.
    required convenience init(coder aDecoder: NSCoder) {
        let fname = aDecoder.decodeObject(forKey: "first") as! String
        let lname = aDecoder.decodeObject(forKey: "last") as! String
        let emailAddr = aDecoder.decodeObject(forKey: "emailAddr") as! String
        let phoneNum = aDecoder.decodeObject(forKey: "phoneNum") as! String
        self.init(first: fname, last: lname, emailAddress: emailAddr, phoneNumber: phoneNum)
    }
    
    //  Encoder for when Person is getting saved to preferences.
    func encode(with aCoder: NSCoder) {
        aCoder.encode(first, forKey: "first")
        aCoder.encode(last, forKey: "last")
        aCoder.encode(emailAddr, forKey: "emailAddr")
        aCoder.encode(phoneNum, forKey: "phoneNum")
    }
}
