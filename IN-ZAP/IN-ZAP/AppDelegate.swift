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

    func applicationDidBecomeActive(_ notification: Notification) {
        let pb = NSPasteboard.general
        if let string = pb.string(forType: .string) {
            print("string from pasteboard: \(string)")
        }
    }

}

