//
//  ViewController.swift
//  IN-ZAP
//
//  Created by HASHIMOTO Wataru on 2020/08/06.
//  Copyright © 2020 Prancee. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    let windowObserver: Any? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(forName: NSWindow.didBecomeKeyNotification,
                                               object: nil,
                                               queue: OperationQueue.main) { [weak self] (note) in
                                                guard let self = self, let window = note.object as? NSWindow, window == self.view.window else {
                                                    return
                                                }
                                                print("window did become key")
                                                
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

