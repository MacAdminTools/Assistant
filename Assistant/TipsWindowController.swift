//
//  TipsWindowController.swift
//  Assistant
//
//  Created by mathieu on 26.08.18.
//  Copyright © 2018 Mathieu Knecht. All rights reserved.
//

import Foundation
import Cocoa

class TipsWindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.standardWindowButton(.closeButton)?.isHidden = true
        self.window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        self.window?.standardWindowButton(.zoomButton)?.isHidden = true
        self.window?.titlebarAppearsTransparent = true
        self.window?.titleVisibility = .hidden
        self.window?.styleMask.insert(NSWindow.StyleMask.fullSizeContentView)
        self.window?.titlebarAppearsTransparent = true
        
        if let window = window, let screen = window.screen {
            let offsetFromRightOfScreen: CGFloat = 0
            let offsetFromTopOfScreen: CGFloat = 20
            let screenRect = screen.visibleFrame
            let newOriginY = screenRect.maxY - window.frame.height - offsetFromTopOfScreen
            let newOriginX = screenRect.maxX - window.frame.width - offsetFromRightOfScreen
            //window.setFrameOrigin(NSPoint(x: newOriginX, y: newOriginY))
            window.setFrame(NSRect(x: newOriginX, y: newOriginY, width: 120, height: 120), display: true)
        }
        
        //self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        //NSApp.activate(ignoringOtherApps: true)
    }
    
    func setTip (tip: [String: Any]) {
        guard let view = tip["view"] as? [String: Any],
            let frame = tip["frame"] as? [String: Float],
            let x = frame["x"],
            let y = frame["y"],
            let width = frame["width"],
            let height = frame["height"]
            else{
                print("malformed tip")
                return
        }
        
        if let tipVC = self.window?.contentViewController as? TipsViewController {
            tipVC.displayTip(tip: view)
        }
        
        if let screen = NSScreen.main {
            let finalX = x >= 0 ? x : Float(screen.frame.width) + x
            let finalY = y >= 0 ? y : Float(screen.frame.height) + y
            
            self.setFrame(x: finalX, y: finalY, width: width, height: height)
            
        }
    }
    
    func setFrame (x: Float, y: Float, width: Float, height: Float) {
        if let window = window/*, let screen = window.screen*/ {
            window.setFrame(NSRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(width), height: CGFloat(height)), display: true)
        }
    }
}

