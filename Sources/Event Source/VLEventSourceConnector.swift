//
//  VLEventSourceConnector.swift
//  
//
//  Created by Gaurav Vig on 09/01/23.
//

import Foundation
import os.log

protocol VLEventSourceConnectorDelegate:AnyObject {
    // Tells the delegate that the task finished transferring data.
    func urlSession(_ session: URLSession,
                           task: URLSessionTask,
                           didCompleteWithError error: Error?)
    
    // Tells the delegate that the data task received the initial reply (headers) from the server.
    func urlSession(_ session: URLSession,
                           dataTask: URLSessionDataTask,
                           didReceive response: URLResponse,
                           completionHandler: @escaping (URLSession.ResponseDisposition) -> Void)

    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive data: Data)
}

final class VLEventSourceConnector:NSObject, URLSessionDataDelegate {
    
    private var sessionTask: URLSessionDataTask?
    weak var delegate:VLEventSourceConnectorDelegate?
    private let logger: OSLog = OSLog(subsystem: "com.viewlift.notificationService", category: "VLEventSource")
    
    init(with delegate:VLEventSourceConnectorDelegate, defaultConfig:VLAppleNotificationService.DefaultConfig, connectionUrl url:URL) {
        self.delegate = delegate
        super.init()
        self.connectToSSE(with: defaultConfig, url: url)
    }
    
    private func connectToSSE(with config:VLAppleNotificationService.DefaultConfig, url:URL) {
        
        var sseUrl = url
        let queryItems = VLRequestQueryParams().getQueryParams()
        if queryItems.count > 0, var urlComponent = URLComponents(url: sseUrl, resolvingAgainstBaseURL: false) {
            urlComponent.queryItems = queryItems
            if let updatedUrl = urlComponent.url {
                sseUrl = updatedUrl
            }
        }
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = config.idleTimeout
        let session = URLSession.init(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        var urlRequest = URLRequest(url: sseUrl,
                                    cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData,
                                    timeoutInterval: config.idleTimeout)
        urlRequest.httpMethod = config.method
        urlRequest.httpBody = config.body
        urlRequest.allHTTPHeaderFields = config.headers
        print("Request >>> \(urlRequest)")
        let task = session.dataTask(with: urlRequest)
        task.resume()
        sessionTask = task
    }
    
    func stopConnection() {
        sessionTask?.cancel()
    }
    
    // Tells the delegate that the task finished transferring data.
    func urlSession(_ session: URLSession,
                           task: URLSessionTask,
                           didCompleteWithError error: Error?) {
		print(#function)
        delegate?.urlSession(session, task: task, didCompleteWithError: error)
    }

    // Tells the delegate that the data task received the initial reply (headers) from the server.
    func urlSession(_ session: URLSession,
                           dataTask: URLSessionDataTask,
                           didReceive response: URLResponse,
                           completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
		print(#function)
        delegate?.urlSession(session, dataTask: dataTask, didReceive: response, completionHandler: completionHandler)
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
		print(#function)
        delegate?.urlSession(session, dataTask: dataTask, didReceive: data)
    }
}
