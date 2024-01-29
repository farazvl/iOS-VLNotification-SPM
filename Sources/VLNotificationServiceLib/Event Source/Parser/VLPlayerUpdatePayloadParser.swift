//
//  VLPlayerUpdatePayloadParser.swift
//
//
//  Created by Japneet Singh on 22/01/24.
//

import Foundation

struct VLPlayerUpdatePayloadParser: VLEventPayloadParser {
    
    typealias T = VLPlayerUpdatePayload
    
    func parseEventPayload(from eventPayload: VLEventPayload) throws -> VLPlayerUpdatePayload {
        guard let payload = eventPayload.payload, !payload.isEmpty,
              let payloadData = payload.data(using: .utf8)
        else {
            throw VLEventParseError.dataParseError
        }
        return try parsePlayerStatusPayload(with: payloadData, for: eventPayload.contentMetadata)
    }
    
    private func parsePlayerStatusPayload(with payloadData:Data, for contentMetadata:VLEventPayload.ContentMetadata?) throws -> VLPlayerUpdatePayload {
        guard var playerUpdate = try? JSONDecoder().decode(VLPlayerUpdatePayload.self, from: payloadData) else {
            throw VLEventParseError.playerUpdatePayloadParseError
        }
        if let contentMetadata {
            playerUpdate.updateContentMetadata(contentMetadata: contentMetadata)
        }
        return playerUpdate
    }
    
}
