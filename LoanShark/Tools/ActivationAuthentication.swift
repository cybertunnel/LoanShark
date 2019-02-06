//
//  ActivationAuthentication.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/6/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Foundation

/**
 Used to perform authentication against the Jamf Pro instance.
 */
class ActivationAuthentication {
    /**
     TODO: Use UAPI to grab LDAP groups the user is a part of, and grab from Preferences the groups authorized to administer the loaner.
     /auth/current gets the Group IDs, but nothing else right now.
     Asked #jss-api for help, waiting for response.
    */
    
    //  MARK: Functions
    
    
    /**
     Checks to see if the authenticated user has access to perform loaner management.
     - Parameter user: The user who is being checked for permission as String.
     - returns: Bool
    */
    func doesHaveAccess(_ user: String) -> Bool {
        return false
    }
    
    /**
     Authenticates the user to the Jamf Pro Server using the username and password provided.
     - Parameters:
        - user: The username of the user as String
        - password: The password of the user as String
     
     - Note: This calls on a private function
    */
    func authenticate(_ user: String, _ password: String) -> Bool {
        return false
    }
}
