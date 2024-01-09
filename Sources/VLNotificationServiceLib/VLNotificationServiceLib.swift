// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public class VLAppleNotificationService {
    
    private var authorizationToken:String {
        didSet {
            self.tokenDetails = TokenParser().parseToken(using: JWTTokenParser(), for: authorizationToken)
            self.eventSource?.authorizationToken = authorizationToken
        }
    }
    
    internal var tokenDetails:VLTokenDetails?
    internal var eventSource:VLEventSource?
    private let eventHandler:any VLEventHandler
    
    public init(with authToken:String, eventHandler:any VLEventHandler) {
        self.authorizationToken = authToken
        self.eventHandler = eventHandler
        self.tokenDetails = JWTTokenParser().jwtTokenParser(jwtToken: authToken)
        
    }
    
    public func updateAuthorizationToken(_ updatedToken:String) {
        self.authorizationToken = updatedToken
        self.updateHeaders()
    }
    
    public func connectToServer() {
        if eventSource == nil {
            self.eventSource = VLEventSource(config: getDefaultConfig(eventHandler: eventHandler))
        }
        self.eventSource?.start()
    }
    
    private func getDefaultConfig(eventHandler:any VLEventHandler) -> VLAppleNotificationService.DefaultConfig {
        let defaultConfig = DefaultConfig(handler: eventHandler, url: getConnectionUrl(), authToken: authorizationToken)
        return defaultConfig
    }
    
    public func disconnectFromServer() {
        eventSource?.stop()
    }
    
    internal func getAuthorizationToken() -> String {
        return authorizationToken
    }
}

extension VLAppleNotificationService:VLAPIRequestParamBuilder, VLRequestAPIBuilder {
    private func getConnectionUrl() -> URL? {
        if let connectionUrlString = getConnectionUrlString(),
           let connectionUrl = URL(string: connectionUrlString.appending(getRequestParam(using: tokenDetails))) {
           return connectionUrl
        }
        return nil
    }
    
    private func updateHeaders() {
        eventSource?.updateDefaultConfigHeader(authToken: authorizationToken)
    }
    
    /// Struct describing the configuration of the EventSource
    struct DefaultConfig {
        let handler: any VLEventHandler
        let url: URL?
        /// The method to use for the EventSource connection
        var method: String = "GET"
        /// Optional body to be sent with the initial request
        var body: Data? = nil
        /// Additional headers to be set on the request
        var headers: [String: String]
        /// The minimum amount of time to wait before reconnecting after a failure
        var minReconnectTime: TimeInterval = 7.0
        /// The maximum amount of time to wait before reconnecting after a failure
        var maxReconnectTime: TimeInterval = 30.0
        /// The minimum amount of time for an EventSource connection to remain open before allowing connection
        /// backoff to reset.
        var backoffResetThreshold: TimeInterval = 60.0
        /// The maximum amount of time between receiving any data before considering the connection to have
        /// timed out.
        public var idleTimeout: TimeInterval = 300.0

        /// Create a new configuration with an EventHandler and a URL
        init(handler: any VLEventHandler, url: URL?, authToken:String?) {
            self.handler = handler
            self.url = url
            self.headers = VLRequestHeaderBuilder(Authorization: authToken).getRequestHeader()
        }
        
        mutating func updateHeaders(authToken:String) {
            self.headers = VLRequestHeaderBuilder(Authorization: authToken).getRequestHeader()
        }
    }
}

struct VLConfiguration:Decodable {
    let connectionUrl:String?
    private enum CodingKeys:String, CodingKey {
        case connectionUrl = "ApiUrl"
    }
}
