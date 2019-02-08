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
    
    //  MARK: Enumerations
    enum AuthenticationError: Error {
        case UnableToAuthenticate(String)
    }
    
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
    func authenticate(_ user: String, _ password: String) throws -> Bool {
        Log.write(.info, Log.Category.authenticator, "Attempting to authenticate \(user) using the JPS")
        
        guard let host = Preferences.sharedInstance.jssURL else {
            throw AuthenticationError.UnableToAuthenticate("Server host has not been configured.")
        }
        Log.write(.debug, Log.Category.authenticator, "The server attempting to perform authentication to is \(host)")
        
        //  Encodes login credentials to Base64
        let loginData = String(format: "%@:%@", user, password).data(using: String.Encoding.utf8)
        let base64LoginData = loginData?.base64EncodedString()
        
        //  Creates the request
        let url = URL(string: host)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginData!)", forHTTPHeaderField: "Authorization")
        
        //  Performs the request
        var running = true
        var authorized = false
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse {
                //  Checks status code returned by the http server.
                if httpStatus.statusCode == 200 {
                    Log.write(.info, Log.Category.authenticator, "\(user) has been successfully authenticated.")
                    authorized = true
                    do {
                        let jsonObj = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                        try! Token.sharedInstance.setToken(jsonObj!, user: user)
                    }
                    running = false
                }
                else {
                    Log.write(.error, Log.Category.authenticator, "Unable to authenticate \(user), recieved status code of \(httpStatus.statusCode)")
                    authorized = false
                    running = false
                }
            }
        }
        task.resume()
        while running {
            sleep(1)
        }
        return authorized
    }
}
