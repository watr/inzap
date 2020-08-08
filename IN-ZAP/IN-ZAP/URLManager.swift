//
//  URLManager.swift
//  IN-ZAP
//
//  Created by HASHIMOTO Wataru on 2020/08/08.
//  Copyright © 2020 Prancee. All rights reserved.
//

import Foundation

extension URL {
    var pairedQuery: [String: String] {
        if let components: [(String, String)] = URLComponents(url: self, resolvingAgainstBaseURL: true)?.queryItems?.filter({
            if case (_, _?) = ($0.name, $0.value) {
                return true
            } else {
                return false
            }
        }).map({($0.name, $0.value!)})
        {
            return Dictionary(uniqueKeysWithValues: components)
        }
        else {
            return [:]
        }
    }
}

enum ZeplinAppURL {
    static let webScheme = "https"
    static let appScheme = "zpl"
    static let webHost = "app.zeplin.io"
    static let shortenedHost = "zpl.io"
    
    case shortened(url: URL), web(url: URL), customSheme(url: URL)
    
    init?(url: URL) {
        if case let (scheme?, host?) = (url.scheme, url.host),
            (scheme.caseInsensitiveCompare(ZeplinAppURL.webScheme) == .orderedSame &&
                host.caseInsensitiveCompare(ZeplinAppURL.webHost) == .orderedSame)
        {
            let components = url.pathComponents
            if components.count == 5 &&
                    components[1] == "project" &&
                    components[3] == "screen"
            {
                self = .web(url :url)
            }
            else {
                return nil
            }
        }
        else if case let (scheme?, host?) = (url.scheme, url.host),
            (scheme.caseInsensitiveCompare(ZeplinAppURL.webScheme) == .orderedSame &&
                host.caseInsensitiveCompare(ZeplinAppURL.shortenedHost) == .orderedSame)
        {
            self = .shortened(url: url)
        }
        else if let scheme = url.scheme,
            scheme.caseInsensitiveCompare(ZeplinAppURL.appScheme) == .orderedSame
        {
            let dic = url.pairedQuery
            
            if case (_?, _?) = (dic["sid"], dic["pid"]) {
                self = .customSheme(url: url)
            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
    }
    
    func customSchemeURL() -> URL? {
        switch self {
        case let .web(url):
            let components = url.pathComponents
            let screen = components[4]
            let project = components[2]
            return URL(string: "\(ZeplinAppURL.appScheme)://screen?sid=\(screen)&pid=\(project)")!
        default:
            return nil
        }
    }
    
}

class URLManager: NSObject, URLSessionTaskDelegate {
    var handleExpandedURL: ((URL) -> Void)? = nil
    
    func expandShortenedURL(zurl: ZeplinAppURL) {
        switch zurl {
        case .shortened(let url):
            let session =
                URLSession(configuration: URLSessionConfiguration.default,
                           delegate: self,
                           delegateQueue: OperationQueue.main)
            let task = session.downloadTask(with: url)
            task.resume()
        default:
            break
        }
    }
    
    //MARKL URLSessionTaskDelegate
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) {
        if let url = request.url, let handler = self.handleExpandedURL {
            handler(url)
        }
        // refuse the redirect by 'nil'
        completionHandler(nil)
    }
    
}
