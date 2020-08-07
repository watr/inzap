//
//  AppDelegate.swift
//  IN-ZAP
//
//  Created by HASHIMOTO Wataru on 2020/08/06.
//  Copyright © 2020 Prancee. All rights reserved.
//

import Cocoa

extension URL {
    enum ZeplinURL {
        case web, app
    }
    
    var isZeplinShortenURL: Bool {
        if case let (scheme?, host?) = (self.scheme, self.host),
            (scheme.caseInsensitiveCompare("https") == .orderedSame &&
                host.caseInsensitiveCompare("zpl.io") == .orderedSame)
        {
            return true
        }
        return false
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, URLSessionTaskDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        let pb = NSPasteboard.general
        if let string = pb.string(forType: .string), let url = URL(string: string) {
            print("string from pasteboard: \(string)")
            print("url from pasteboard: \(url)")
            if url.isZeplinShortenURL {
                let session =
                    URLSession(configuration: URLSessionConfiguration.default,
                               delegate: self, delegateQueue: OperationQueue.main)
                let task = session.downloadTask(with: url)
                task.resume()
                
               
            }
        }
    }
    
    //MARKL URLSessionTaskDelegate
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) {
        let redirectToURL = request.url!
        print("redirect to (maybe original url) \(redirectToURL)")
    }

}

