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
    var pasteboardString: String? = nil
    var urlToOpen: URL? = nil {
        didSet {
            self.update()
        }
    }
    
    @IBOutlet weak var textField: NSTextField!
    
    @IBOutlet weak var openButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        update()
        
        self.urlManager.handleExpandedURL = { (expanded) in
            self.handle(url: expanded)
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
                                                        self.handleUserGiven(string: string)
                                                    }
        }
    }
    
    func handleUserGiven(string: String) {
        guard let url = URL(string: string),
            let _ = ZeplinAppURL(url: url),
            self.pasteboardString != string else {
            return
        }
        
        self.pasteboardString = string
        self.handle(url: url)
    }
    
    func handle(url: URL) {
        guard let zurl = ZeplinAppURL(url: url) else {
            self.urlToOpen = url
            return
        }
        
        self.handle(zurl: zurl)
    }
    
    func handle(zurl: ZeplinAppURL) {
        switch zurl {
        case .shortened:
            self.urlManager.expandShortenedURL(zurl: zurl)
        case .web:
            self.urlToOpen = zurl.customSchemeURL()
            break
        case .customSheme(url: let url):
            self.urlToOpen = url
            break
        }
    }
    
    func update() {
        self.textField.stringValue = self.urlToOpen?.absoluteString ?? ""
        self.openButton.isEnabled = self.urlToOpen != nil
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func open() {
        guard let url = self.urlToOpen else {
            return
        }
        NSWorkspace.shared.open(url)
    }

    @IBAction func open(_ sender: Any) {
        self.open()
    }
    
    deinit {
        if let windowObserver = self.windowObserver {
            NotificationCenter.default.removeObserver(windowObserver)
        }
    }

}

