//
//  AppDelegate.swift
//  Assistant
//
//  Created by mathieu on 26.08.18.
//  Copyright © 2018 Mathieu Knecht. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    @IBOutlet weak var menu: NSMenu!
    var tipWindow: TipsWindowController?
    var permTipWindow: TipsWindowController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.image = NSImage(named: NSImage.Name(rawValue: "assistant_icon_19"))
        statusItem.menu = menu
        
        NotificationsManager.shared.registerForNotification(name: .HostNotification) { (dic) in
            
            if let tip = dic as? [String: Any] {
                
                if let command = tip["command"] as? String {
                    switch command {
                    case "terminate":
                        //LogManager.shared.log(line: "Assistant terminated")
                        exit(0)
                    case "close":
                        //LogManager.shared.log(line: "Assistant close window")
                        self.closeWindow()
                    case "permClose":
                        //LogManager.shared.log(line: "Assistant close permanent window")
                        self.permTipWindow?.close()
                    case "display":
                        /*if let currentWC = self.tipWindow {
                            currentWC.setTip(tip: tip)
                        }else{
                            self.tipWindow = self.displayWC(tip: tip)
                        }*/
                        if let currentWC = self.tipWindow {
                            currentWC.close()
                        }
                        self.tipWindow = self.displayWC(tip: tip)
                    case "displayPerm":
                        self.permTipWindow = self.displayWC(tip: tip)
                    default: break;
                    }
                }
            }
        }
    }
    
    func displayWC (tip: [String: Any]) -> TipsWindowController? {
        if let tipWC = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "TipsWindowController")) as? TipsWindowController {
            tipWC.setTip(tip: tip)
            return tipWC
        }
        return nil
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func closeWindow () {
        self.tipWindow?.close()
    }
    
}

extension Notification.Name {
    static let HostNotification = Notification.Name("ch.altab.Assistant.DistributedNotification")
}

