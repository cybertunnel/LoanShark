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
    
    //  MARK: Variables
    private var accessGroups: Array <String>?
    
    //  MARK: Enumerations
    enum AuthenticationError: Error {
        case UnableToAuthenticate(String)
        case NoAccessGroups
        case NoSharedSecretStored
        case UserDoesNotExist(String)
    }
    
    //  MARK: Functions
    
    
    /**
     Checks to see if the authenticated user has access to perform loaner management.
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
                authorized = false
                running = false
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
            else {
                Log.write(.error, Log.Category.authenticator, "No response from web server.")
                authorized = false
                running = false
            }
            
        }
        task.resume()
        while running {
            sleep(1)
        }
        return authorized
    }
    
    /**
     Obtains information of the provided user using the Jamf Pro API
     */
    func getUserDetails(user: String, apiUser: String, apiPassword: String) throws -> Person? {
        Log.write(.info, Log.Category.authenticator, "Attempting to authenticate \(user) using the JPS")
        
        let host = try self.getURI()
        Log.write(.debug, Log.Category.authenticator, "The server attempting to perform authentication to is \(host)")
        
        //  Encodes login credentials to Base64
        let loginData = String(format: "%@:%@", apiUser, apiPassword).data(using: String.Encoding.utf8)
        let base64LoginData = loginData?.base64EncodedString()
        
        //  Creates the request
        
        let uri = host + "/JSSResource/users/name/\(user)"
        
        let url = URL(string: uri)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginData!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        //  Performs the request
        var running = true
        var userObj: Person?
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                running = false
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse {
                //  Checks status code returned by the http server.
                if httpStatus.statusCode == 200 {
                    Log.write(.info, Log.Category.authenticator, "\(user) has been successfully authenticated.")
                    do {
                        guard let jsonObj = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
                            return
                        }
                        guard let userDetails = jsonObj["user"] as? [String:Any] else {
                            return
                        }
                        
                        guard let name = userDetails["full_name"] as? String else {
                            return
                        }
                        guard let email = userDetails["email"] as? String else {
                            return
                        }
                        guard let phone = userDetails["phone_number"] as? String else {
                            return
                        }
                        
                        var first = ""
                        var last = ""
                        if name.contains(",") {
                            first = String(name.split(separator: ",")[1])
                            last = String(name.split(separator: ",")[0])
                        } else {
                            first = String(name.split(separator: " ")[0])
                            last = String(name.split(separator: " ")[1])
                        }
                        
                        userObj = Person(first: first, last: last, emailAddress: email, phoneNumber: phone)
                    }
                    running = false
                }
                else {
                    Log.write(.error, Log.Category.authenticator, "Unable to authenticate \(user), recieved status code of \(httpStatus.statusCode)")
                    running = false
                }
            }
            else {
                Log.write(.error, Log.Category.authenticator, "No response from web server.")
                running = false
            }
            
        }
        task.resume()
        while running {
            sleep(1)
        }
        
        return userObj
    }
    
    /**
     Authenicates a user using a shared secret.
     - Parameters:
        - secret: The secret given to the authentication window.
     
     - Note: This should only be used if not using Jamf Pro
    */
    func authenticate(secret: String) throws -> Bool {
        guard let sharedSecret = Preferences.sharedInstance.sharedSecret else {
            Log.write(.error, Log.Category.authenticator, "Shared Secret not in preferences.")
            throw AuthenticationError.NoSharedSecretStored
        }
        Log.write(.debug, Log.Category.authenticator, "Hash provided: " + secret.sha256().uppercased())
        return sharedSecret.uppercased() == secret.sha256().uppercased()
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
