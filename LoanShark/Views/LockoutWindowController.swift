//
//  LockoutWindowController.swift
//  LoanShark
//
//  Created by Tyler Morgan on 3/27/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa

class LockoutWindowController: NSWindowController {

    var windows = [NSWindow]()
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
        // Display Front Window
        guard let window = self.window else {
            Log.write(.error, Log.Category.view, "Lockout window is not set")
            self.close()
            return
        }
        
        window.level = NSWindow.Level.init(Int(CGWindowLevelForKey(.maximumWindow)))
        
        window.isOpaque = true
        
        
        for screen in NSScreen.screens {
            let view = NSVisualEffectView()
            view.blendingMode = .behindWindow
            view.material = .dark
            view.state = .active
            
            let window = NSWindow(contentRect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: screen.frame.width, height: screen.frame.height)), styleMask: .borderless, backing: .buffered, defer: false, screen: screen)
            window.backgroundColor = .white
            window.contentView = view
            window.makeKeyAndOrderFront(self)
            window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.maximumWindow)) - 1)
            self.windows.append(window)
        }
    }
}
