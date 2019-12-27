//
//  Token.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/5/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Foundation

/**
 Token object for Jamf Pro API
 */

class Token {
    
    
    //  MARK: Enumerations
    enum TokenGenerationError: Error {
        case jsonParsingError(String)
        case tokenExpired
    }
    
    //  MARK: Variables
    
    /**
     Singleton
     */
    static var sharedInstance = Token()
    
    /**
     Token hash used to authenticate to the Jamf Pro API
     */
    var token: String?
    
    /**
     When the token will expire in epoch
     */
    var expires: Double? // When the token will expire in Unix
    
    /**
     Checks if the token has expired
     */
    var isExpired: Bool {
        get {
            let hoursRemaining = Date(timeIntervalSince1970: self.expires ?? 0.0).hours(from: Date())
            if hoursRemaining >= 1 {
                return false
            }
            else {
                return true
            }
        }
    }
    
    /**
     The user who is authenticated.
     */
    var user: String? //    User who is authenticated
    
    // MARK: Functions
    
    /**
    Sets the token object using the provided JSON.
    - parameters:
        - json: JSON object provided in Dictionary format
        - user: The user who is generating the token
     - throws: An error of type TokenGenerationError.jsonParsingError if the json's parameter does not contain token element or expires element.
     */
    func setToken(_ json: Dictionary <String, Any>, user: String) throws {
        guard let token = json["token"] as? String else {
            throw TokenGenerationError.jsonParsingError("Error while parsing token field of json.")
        }
        guard let expires = json["expires"] as? Double else {
            throw TokenGenerationError.jsonParsingError("Error while parsing expires field of json.")
        }
        
        self.token = token
        self.expires = expires
    }
    
}
