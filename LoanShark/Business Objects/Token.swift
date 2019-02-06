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
    }
    
    //  MARK: Variables
    
    static var sharedInstance = Token() // Singleton
    
    var token: String? //   Token element for accessing Jamf Pro API
    var expires: Double? // When the token will expire in Unix
    var isExpired: Bool {   //  Checks if the token has expired
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
    var user: String? //    User who is authenticated
    
    /**
    Sets the token object using the provided JSON.
     parameters:
         - json: JSON object provided in Dictionary format
     throws: `TokenGenerationError.jsonParsingError` if the `json` parameter does not contain `token` element or `expires` element.
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
