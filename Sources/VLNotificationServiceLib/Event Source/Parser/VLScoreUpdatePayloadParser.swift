//
//  VLScoreUpdatePayloadParser.swift
//  VLAppleNotificationService
//
//  Created by Gaurav Vig on 10/01/23.
//

import Foundation

struct VLScoreUpdatePayloadParser:VLEventPayloadParser {
    
    typealias T = VLScoreUpdatePayload
    
    func parseEventPayload(from eventPayload: VLEventPayload) throws -> VLScoreUpdatePayload {
        guard let payload = eventPayload.payload, !payload.isEmpty,
              let payloadData = payload.data(using: .utf8)
        else {
            throw VLEventParseError.scoreUpdatePayloadParseError
        }

        return try parseScoreUpdatePayload(with: payloadData, for: eventPayload.contentMetadata)
    }
    
    private func parseScoreUpdatePayload(with payloadData:Data, for contentMetadata:VLEventPayload.ContentMetadata?) throws -> VLScoreUpdatePayload {
        guard var scoreUpdate = try? JSONDecoder().decode(VLScoreUpdatePayload.self, from: payloadData) else {
            throw VLEventParseError.scoreUpdatePayloadParseError
        }
        if let contentMetadata {
            scoreUpdate.updateContentMetadata(contentMetadata: contentMetadata)
        }
        return scoreUpdate
    }
}
