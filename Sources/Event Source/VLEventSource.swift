//
//  VLEventSource.swift
//  VLAppleNotificationService
//
//  Created by Gaurav Vig on 09/01/23.
//

import Foundation
import os.log

typealias ConnectionHandler = (() -> ())

protocol VLEventSourceConnectionProtocol  {
    func start()
    func stop()
}

class VLEventSource: NSObject, URLSessionDataDelegate, VLEventSourceConnectionProtocol {

    #if !os(Linux)
    private let logger: OSLog = OSLog(subsystem: "com.viewlift.notificationService", category: "VLEventSource")
    #endif

    private var config:VLAppleNotificationService.DefaultConfig
    private let delegateQueue:DispatchQueue = DispatchQueue(label: "VLEventSourceQueue")
    private(set) var connectionState:ConnectionState = .notStarted
    private var reconnectTime:TimeInterval
    private var connectedTime:Date?
    private var reconnectionAttempts:Int = 0
    
    private var eventSourceConnector:VLEventSourceConnector?
    private var eventParser:VLEventParser?
    private var eventSourceParser:VLEventSourceParser?
    
    private var errorHandlerAction: ConnectionState? = nil
    private var sessionTask: URLSessionDataTask?

    init(config: VLAppleNotificationService.DefaultConfig) {
        self.config = config
        self.reconnectTime = config.reconnectTime
    }

    func start() {
        delegateQueue.async {
            guard self.connectionState == .notStarted
            else {
                #if !os(Linux)
                os_log("Start method called on this already-started EventSource object. Doing nothing", log: self.logger, type: .info)
                #endif
                return
            }
            self.connect()
        }
    }

    func stop() {
        if connectionState == .open {
            config.handler.onClosed()
        }
        connectionState = .shutdown
        eventSourceConnector?.stopConnection()
    }

    func updateDefaultConfigHeader(authToken:String) {
        self.config.updateHeaders(authToken: authToken)
    }
    
    private func connect() {
        guard let url = self.config.url else {return}
        #if !os(Linux)
        os_log("Starting EventSource client", log: logger, type: .info)
        #endif
        if eventParser == nil {
            self.eventParser = VLEventParser(eventHandler: self.config.handler)
        }
        eventSourceConnector = VLEventSourceConnector(with: self, defaultConfig: self.config, connectionUrl: url)
    }

    private func afterComplete() {
        var nextState: ConnectionState = .closed
        let currentState: ConnectionState = connectionState
        if errorHandlerAction == .shutdown {
            nextState = .shutdown
        }
        connectionState = nextState
        #if !os(Linux)
        os_log("State: %@ -> %@", log: logger, type: .debug, currentState.rawValue, nextState.rawValue)
        #endif

        if currentState == .open {
            config.handler.onClosed()
        }

        if nextState != .shutdown {
            reconnect()
        }
        else {
            errorHandlerAction = nil
        }
    }

    private func reconnect() {
        reconnectionAttempts += 1

        if let connectedTime = connectedTime, Date().timeIntervalSince(connectedTime) >= config.backoffResetThreshold {
            reconnectionAttempts = 0
        }

        let maxSleep = min(config.maxReconnectTime, reconnectTime * pow(2.0, Double(reconnectionAttempts)))
        let sleep = maxSleep / 2 + Double.random(in: 0...(maxSleep/2))

        #if !os(Linux)
        os_log("Waiting %.3f seconds before reconnecting...", log: logger, type: .info, sleep)
        #endif
        delegateQueue.asyncAfter(deadline: .now() + sleep) {
            self.connect()
        }
    }
}

extension VLEventSource:VLEventSourceConnectorDelegate {
    // Tells the delegate that the task finished transferring data.
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        if let error = error {
            if connectionState != .shutdown {
#if !os(Linux)
                os_log("Connection error: %@", log: logger, type: .info, error.localizedDescription)
#endif
                self.config.handler.onError(error: error)
            } else {
                errorHandlerAction = .shutdown
            }
        } else {
#if !os(Linux)
            os_log("Connection unexpectedly closed.", log: logger, type: .info)
#endif
        }
        
        afterComplete()
    }
    
    // Tells the delegate that the data task received the initial reply (headers) from the server.
    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
#if !os(Linux)
        os_log("initial reply received", log: logger, type: .debug)
#endif
        let httpResponse = response as! HTTPURLResponse
        if (200..<300).contains(httpResponse.statusCode) {
            connectedTime = Date()
            connectionState = .open
            config.handler.onOpened()
            completionHandler(.allow)
        } else {
#if !os(Linux)
            os_log("Unsuccessful response: %d", log: logger, type: .info, httpResponse.statusCode)
#endif
            self.config.handler.onError(error: UnsuccessfulResponseError(responseCode: httpResponse.statusCode))
            completionHandler(.cancel)
        }
    }
    
    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive data: Data) {
#if !os(Linux)
        if let value = try? JSONSerialization.jsonObject(with: data) as? [String:Any] {
            os_log("Response value: %@", log: logger, type: .info, value)
            print("Response value: \(value)")
        }
#endif
        do  {
            let eventSourceObject = try VLEventSourceParser().parse(data: data)
            if eventSourceObject.heartbeat != nil {
                connectionState = .open
            }
            else if let payloadString = eventSourceObject.payload {
                handleEventPayload(payloadString: payloadString)
            }
        }
        catch let error {
            self.config.handler.onError(error: error)
        }
    }
    
    
    private func handleEventPayload(payloadString:String) {
        do  {
            if let eventPayload:VLEventPayload = TokenParser().parseToken(using: EventPayloadTokenParser(), for: payloadString) {
                try self.eventParser?.parse(eventPayload: eventPayload)
            }
        }
        catch let error {
            self.config.handler.onError(error: error)
        }
    }
}
