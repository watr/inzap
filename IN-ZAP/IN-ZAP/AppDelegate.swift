//
//  AppDelegate.swift
//  IN-ZAP
//
//  Created by HASHIMOTO Wataru on 2020/08/06.
//  Copyright © 2020 Prancee. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if flag {
            return false
        }
        else {
            NSApplication.shared.windows.first?.makeKeyAndOrderFront(self)
            return true
        }
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        if NSApplication.shared.windows.count == 1 &&
            !NSApplication.shared.windows.first!.isVisible
        {
            NSApplication.shared.windows.first!.makeKeyAndOrderFront(self)
        }        
    }
}

