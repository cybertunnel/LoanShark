//
//  AgentMenuSegue.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/6/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa

/**
 Class to assist in handling of the transition between a menu item in the agent to authentication screen to the destination viewcontroller.
 */
class AgentMenuSegue: NSStoryboardSegue {
    override func perform() {
        ((self.destinationController as! NSWindowController).contentViewController as! AuthenticationViewController).destination = self.identifier
        super.perform()
    }
}
