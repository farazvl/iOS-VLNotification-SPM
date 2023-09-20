//
//  VLEventParser.swift
//  VLAppleNotificationService
//
//  Created by Gaurav Vig on 10/01/23.
//

import Foundation

enum VLEventParseError:Error {
    case dataParseError
    case mobileConnectPayloadParseError
    case scoreUpdatePayloadParseError
    case gameStatePayloadParserError
}

protocol VLEventParserProtocol {
    func parse(eventPayload:VLEventPayload) throws
}

struct VLEventParser:VLEventParserProtocol {
    
    private let eventHandler:any VLEventHandler
    
    init(eventHandler:any VLEventHandler) {
        self.eventHandler = eventHandler
    }
    
    func parse(eventPayload:VLEventPayload) throws {
        try handleEventPayload(eventPayload: eventPayload)
    }
    
    private func handleEventPayload(eventPayload:VLEventPayload) throws {
        if let eventType = eventPayload.eventType {
            switch eventType {
            case .scoreUpdate:
                try parsePayloadInEventPayload(eventPayload: eventPayload, eventPayloadParser: VLScoreUpdatePayloadParser())
            case .mobileSignIn:
                try parsePayloadInEventPayload(eventPayload: eventPayload, eventPayloadParser: VLMobileConnectPayloadParser())
            case .gameState:
                try parsePayloadInEventPayload(eventPayload: eventPayload, eventPayloadParser: VLGameStatePayloadParser())
            default:
                break
            }
        }
    }
    
    private func parsePayloadInEventPayload(eventPayload:VLEventPayload, eventPayloadParser:any VLEventPayloadParser) throws {
        if let parsedObject = try eventPayloadParser.parseEventPayload(from: eventPayload) as? Decodable {
            eventHandler.onMessage(eventType: eventPayload.eventType ?? .none, messageEvent: parsedObject)
        }
    }
}
