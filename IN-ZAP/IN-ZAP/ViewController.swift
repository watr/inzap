//
//  ViewController.swift
//  IN-ZAP
//
//  Created by HASHIMOTO Wataru on 2020/08/06.
//  Copyright © 2020 Prancee. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    let urlManager = URLManager()
    var windowObserver: Any? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.urlManager.handleExpandedURL = { (expanded) in
            self.handleGiven(string: expanded.absoluteString)
        }
        
        self.windowObserver =
            NotificationCenter.default.addObserver(forName: NSWindow.didBecomeKeyNotification,
                                                   object: nil,
                                                   queue: OperationQueue.main) { [weak self] (note) in
                                                    guard let self = self, let window = note.object as? NSWindow, window == self.view.window else {
                                                        return
                                                    }
                                                    
                                                    let pb = NSPasteboard.general
                                                    if let string = pb.string(forType: .string) {
                                                        self.handleGiven(string: string)
                                                    }
                                                    
                                                    print("window did become key")
                                                    
        }
    }

    func handleGiven(string: String) {
        guard let url = URL(string: string), let zurl = ZeplinAppURL(url: url) else {
            return
        }

        switch zurl {
        case .shortened:
            self.urlManager.expandShortenedURL(zurl: zurl)
        case .web:
            if let url = zurl.customSchemeURL() {
                NSWorkspace.shared.open(url)
            }
            break
        case .customSheme(url: let url):
            NSWorkspace.shared.open(url)
            break
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    deinit {
        if let windowObserver = self.windowObserver {
            NotificationCenter.default.removeObserver(windowObserver)
        }
    }

}

