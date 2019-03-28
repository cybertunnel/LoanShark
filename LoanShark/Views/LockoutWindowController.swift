//
//  LockoutWindowController.swift
//  LoanShark
//
//  Created by Tyler Morgan on 3/27/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa


/**
 Custom NSWindowController class to handle displaying the Lockout message screen.
 */
class LockoutWindowController: NSWindowController {

    //  MARK: Variables
    
    var windows = [NSWindow]()
    
    
    //  MARK: Functions
    override func windowDidLoad() {
        super.windowDidLoad()
        
        //  Checks if the window is set
        
        Log.write(.debug, Log.Category.view, "Checking if Lockout Window Controller has a window")
        guard let window = self.window else {
            Log.write(.error, Log.Category.view, "Lockout window is not set")
            self.close()
            return
        }
        
        Log.write(.debug, Log.Category.view, "Bringing Lockout window to very front")
        window.level = NSWindow.Level.init(Int(CGWindowLevelForKey(.maximumWindow)))
        
        //  Cycles through all screens connected to the computer, and creates a window to cover that display.
        for screen in NSScreen.screens {
            Log.write(.debug, Log.Category.view, "Creating window to blur a screen")
            let view = NSVisualEffectView() //  Creates the blurred background
            view.blendingMode = .behindWindow
            view.material = .dark
            view.state = .active
            
            
            //  Creation of the contentRect with x and y being 0 is needed, since it is on the different screen's 0,0.
            let window = NSWindow(contentRect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: screen.frame.width, height: screen.frame.height)), styleMask: .borderless, backing: .buffered, defer: false, screen: screen)
            Log.write(.debug, Log.Category.view, "Created window \(window.description)")
            
            //  Setting the window content information
            window.backgroundColor = .clear
            window.contentView = view
            window.makeKeyAndOrderFront(self)
            
            //  Brings the background blurred windows to the front
            window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.maximumWindow)) - 1)
            
            //  Adds windows to an array so they don't disappear.
            Log.write(.debug, Log.Category.view, "Adding window to array")
            self.windows.append(window)
            Log.write(.debug, Log.Category.view, "Total number of windows created: \(self.windows.count)")
        }
        
        return
    }
}
