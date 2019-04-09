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
    
    
    //  MARK: Variables
    private var accessGroups: Array <String>?
    //  MARK: Enumerations
    enum AuthenticationError: Error {
        case UnableToAuthenticate(String)
        case NoAccessGroups
    }
    
    //  MARK: Functions
    
    
    /**
     Checks to see if the authenticated user has access to perform loaner management.
     - Parameter user: The user who is being checked for permission as String.
     - returns: Bool
    */
    func doesHaveAccess() throws -> Bool {
        Log.write(.info, Log.Category.authenticator, "Seeing if authenticated user has access to manage this loaner device")
        let host = try self.getURI()
        let uri = host + "/uapi/auth/current"
        
        Log.write(.debug, Log.Category.authenticator, "URI: \(uri)")
        
        //  Creates the request
        Log.write(.debug, Log.Category.authenticator, "Creating URL Request")
        let url = URL(string: uri)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer " + Token.sharedInstance.token!, forHTTPHeaderField: "Authorization")
        
        Log.write(.debug, Log.Category.authenticator, "Request: \(request.debugDescription)")
        
        //  Performs the request
        var running = true
        var hasAccess = false
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                running = false
                return
            }
            
            Log.write(.debug, Log.Category.authenticator, "Response: \(response.debugDescription)")
            
            if let httpStatus = response as? HTTPURLResponse {
                //  Checks status code returned by the http server.
                if httpStatus.statusCode == 200 {
                    Log.write(.info, Log.Category.authenticator, "Successfully got response from server")
                    do {
                        Log.write(.debug, Log.Category.authenticator, "Data found: \(data.debugDescription)")
                        let jsonObj = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                        let groupIDs = (jsonObj?["account"] as? [String:Any])?["groupIds"] as? Array <Int>
                        Log.write(.debug, Log.Category.authenticator, "Group IDs discovered: \(groupIDs.debugDescription)")
                        let approved = Preferences.sharedInstance.authorizedGroupIDs ?? []
                        Log.write(.debug, Log.Category.authenticator, "Approved groups: \(approved.debugDescription)")
                        for groupID in groupIDs ?? [] {
                            if approved.contains(groupID) {
                                Log.write(.debug, Log.Category.authenticator, "Found group authorized ID \(groupID) associated with this user.")
                                hasAccess = true
                                running = false
                                return
                            }
                        }
                        running = false
                        return
                    }
                }
                running = false
            }
        }
        
        task.resume()
        while running {
            sleep(1)
        }
        return hasAccess
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
        
        let host = try self.getURI()
        Log.write(.debug, Log.Category.authenticator, "The server attempting to perform authentication to is \(host)")
        
        //  Encodes login credentials to Base64
        let loginData = String(format: "%@:%@", user, password).data(using: String.Encoding.utf8)
        let base64LoginData = loginData?.base64EncodedString()
        
        //  Creates the request
        
        let uri = host + "/uapi/auth/tokens"
        
        let url = URL(string: uri)!
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
    
    /**
     Generates valid URI from the host saved in preferences.
     - returns: URI as String
    */
    private func getURI() throws -> String {
        guard var host = Preferences.sharedInstance.jssURL else {
            throw AuthenticationError.UnableToAuthenticate("Server host has not been configured.")
        }
        
        Log.write(.debug, Log.Category.authenticator, "Attempting to generate URI using base host name of \(host)")
        
        if host.contains("http://") {
            Log.write(.info, Log.Category.authenticator, "Provided host contains HTTP instead of HTTPS, replacing with HTTPS")
            host = host.replacingOccurrences(of: "http://", with: "https://")
            Log.write(.debug, Log.Category.authenticator, "Host value is now: \(host)")
        }
        
        if !host.contains("https://") && !host.contains("https://") {
            Log.write(.info, Log.Category.authenticator, "Provided host does not contain HTTPS, adding HTTPS")
            host = "https://" + host
            Log.write(.debug, Log.Category.authenticator, "Host value is now: \(host)")
        }
        
        Log.write(.debug, Log.Category.authenticator, "Jamf Cloud Instance: \(Preferences.sharedInstance.jamfCloud)")
        
        if Preferences.sharedInstance.jamfCloud && !host.contains(":443") {
            Log.write(.info, Log.Category.authenticator, "Provided host is Jamf Cloud isntance, adding 443 to the port")
            host += ":443"
            Log.write(.debug, Log.Category.authenticator, "Host value is now: \(host)")
        }
        else if !host.contains(":8443") {
            Log.write(.info, Log.Category.authenticator, "Provided host did not include port, adding")
            host += ":8443"
            Log.write(.debug, Log.Category.authenticator, "Host value is now: \(host)")
        }
        
        return host
    }
}
