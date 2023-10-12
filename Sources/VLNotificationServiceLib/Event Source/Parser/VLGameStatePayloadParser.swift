//
//  VLGameStatePayloadParser.swift
//  VLNotificationServiceLib
//
//  Created by Gaurav Vig on 21/02/23.
//

import Foundation

struct VLGameStatePayloadParser:VLEventPayloadParser {
    
    typealias T = VLGameStatePayload
    
    func parseEventPayload(from eventPayload: VLEventPayload) throws -> VLGameStatePayload {
        guard let payload = eventPayload.payload, !payload.isEmpty,
              let payloadData = payload.data(using: .utf8)
        else {
            throw VLEventParseError.gameStatePayloadParserError
        }

        return try parseGameStatePayload(with: payloadData)
    }
    
    private func parseGameStatePayload(with payloadData:Data) throws -> VLGameStatePayload {
        guard let gameState = try? JSONDecoder().decode(VLGameStatePayload.self, from: payloadData) else {
            throw VLEventParseError.gameStatePayloadParserError
        }
        return gameState
    }
}
