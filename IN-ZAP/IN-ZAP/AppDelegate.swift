//
//  AppDelegate.swift
//  IN-ZAP
//
//  Created by HASHIMOTO Wataru on 2020/08/06.
//  Copyright © 2020 Prancee. All rights reserved.
//

import Cocoa

let zeplinWebAppHost = "app.zeplin.io"

extension URL {
    var isZeplinShortenURL: Bool {
        if case let (scheme?, host?) = (self.scheme, self.host),
            (scheme.caseInsensitiveCompare("https") == .orderedSame &&
                host.caseInsensitiveCompare("zpl.io") == .orderedSame)
        {
            return true
        }
        return false
    }
    
    var isZeplinAppConvertible:  Bool {
        if let host = self.host,
            host.caseInsensitiveCompare(zeplinWebAppHost) == .orderedSame
        {
            let components = self.pathComponents
            return (
                components.count == 5 &&
                components[1] == "project" &&
                components[3] == "screen"
            )
        }
        return false
    }
    
    func zeplinAppURL() -> URL? {
        if self.isZeplinAppConvertible {
            let components = self.pathComponents
            return URL(string: "zpl://screen?sid=\(components[4])&pid=\(components[2])")
        }
        return nil
    }
}

func openURLWithZeplinApp(url: URL) {
    print("open url with \(url.absoluteString)")
    NSWorkspace.shared.open(url)
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
            if url.isZeplinAppConvertible {
                openURLWithZeplinApp(url: url.zeplinAppURL()!)
            }
            else if url.isZeplinShortenURL {
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
        let url = redirectToURL
        if redirectToURL.isZeplinAppConvertible {
            openURLWithZeplinApp(url: url.zeplinAppURL()!)
        }
    }

}

