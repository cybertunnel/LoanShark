//
//  Application.swift
//  LoanShark
//
//  Created by Tyler Morgan on 2/14/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa

class Application: NSApplication {
    override func run() {
        ValueTransformer.setValueTransformer(StatusTransformer(), forName: .statusTransformer)
        super.run()
    }
    
    override func activate(ignoringOtherApps flag: Bool) {
        super.activate(ignoringOtherApps: flag)
    }
    
    override var delegate: NSApplicationDelegate? {
        willSet {
            print("Testing")
        }
    }
}
