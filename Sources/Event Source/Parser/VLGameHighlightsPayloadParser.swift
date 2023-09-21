//
//  VLGameHighlightsPayloadParser.swift
//  VLNotificationServiceLib
//
//  Created by Gaurav Vig on 03/04/23.
//

import Foundation

struct VLGameHighlightsPayloadParser:VLEventPayloadParser {
    
    typealias T = VLGameHighlightsPayload
    
    func parseEventPayload(from eventPayload: VLEventPayload) throws -> VLGameHighlightsPayload {
        guard let payload = eventPayload.payload, !payload.isEmpty,
              let payloadData = payload.data(using: .utf8)
        else {
            throw VLEventParseError.gameHighlightsPayloadParserError
        }

        return try parseGameHighlightsPayload(with: payloadData)
    }
    
    private func parseGameHighlightsPayload(with payloadData:Data) throws -> VLGameHighlightsPayload {
        guard let gameState = try? JSONDecoder().decode(VLGameHighlightsPayload.self, from: payloadData) else {
            throw VLEventParseError.gameHighlightsPayloadParserError
        }
        return gameState
    }
}
