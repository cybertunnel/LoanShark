//
//  LockoutWindow.swift
//  LoanShark
//
//  Created by Tyler Morgan on 3/27/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa

class LockoutWindow: NSWindow {
    override var canBecomeKey: Bool {
        return true
    }
    
    override var canBecomeMain: Bool {
        return true
    }
}
