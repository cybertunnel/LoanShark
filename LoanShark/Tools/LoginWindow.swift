//
//  LoginWindow.swift
//  LoanShark
//
//  Created by Tyler Morgan on 5/29/18.
//  Copyright © 2018 Tyler Morgan. All rights reserved.
//

import Foundation

/**
    Handles the AppleEvents for the LoginWindow actions.
 */
class LoginWindow {
    
    
    //  MARK: Functions
    /**
        Logs off the current user using an AppleEvent code.
     */
    static func logoff() {
        do {
            try self.sendEvent(eventCode: kAEReallyLogOut)
        } catch {
            Log.write(.fault, "LoginWindow", "Error occured while attempting to logout the user.")
        }
    }
    
    static private func sendEvent(eventCode: OSType) throws {
        // https://developer.apple.com/library/content/qa/qa1134/_index.html
        // https://stackoverflow.com/questions/37783016/sending-appleevent-fails-with-sandbox
        
        /*
         * You must have the following exeptions in your .entitlements file:
         *
         *  <key>com.apple.security.temporary-exception.apple-events</key>
         *  <array>
         *      <string>com.apple.loginwindow</string>
         *  </array>
         *
         */
        
        var kPSNOfSystemProcess = ProcessSerialNumber(highLongOfPSN: 0, lowLongOfPSN: UInt32(kSystemProcess))
        var targetDesc = AEAddressDesc()
        var status = OSStatus()
        var error = OSErr()
        
        error = AECreateDesc(keyProcessSerialNumber, &kPSNOfSystemProcess, MemoryLayout<ProcessSerialNumber>.size, &targetDesc)
        
        if error != noErr {
            throw NSError(domain: "AECreateDesc", code: Int(error), userInfo: nil)
        }
        
        var event = AppleEvent()
        error = AECreateAppleEvent(kCoreEventClass,
                                   eventCode,
                                   &targetDesc,
                                   AEReturnID(kAutoGenerateReturnID),
                                   AETransactionID(kAnyTransactionID),
                                   &event)
        
        if error != noErr {
            throw NSError(domain: "AECreateAppleEvent", code: Int(error), userInfo: nil)
        }
        
        AEDisposeDesc(&targetDesc)
        
        var reply = AppleEvent()
        
        status = AESendMessage(&event,
                               &reply,
                               AESendMode(kAENoReply),
                               1000)
        
        if status != OSStatus(0) {
            throw NSError(domain: "AESendMessage", code: Int(status), userInfo: nil)
        }
        
        AEDisposeDesc(&event)
        AEDisposeDesc(&reply)
    }
}
