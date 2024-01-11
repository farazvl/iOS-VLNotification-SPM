//
//  File.swift
//  
//
//  Created by NexG on 11/01/24.
//

import Foundation

struct VLChampionTournamentStatusParser: VLEventPayloadParser {
    
    func parseEventPayload(from eventPayload:VLEventPayload) throws -> VLChampionsStatusPayload {
        guard let payload = eventPayload.payload, !payload.isEmpty,
              let payloadData = payload.data(using: .utf8)
        else {
            throw VLEventParseError.dataParseError
        }

        return try parseDeviceRemovePayload(payloadData: payloadData)
    }
    
    private func parseDeviceRemovePayload(payloadData:Data) throws -> VLChampionsStatusPayload {
        do {
            let deviceRemove = try JSONDecoder().decode(VLChampionsStatusPayload.self, from: payloadData)
            return deviceRemove
        }
        catch {
            throw VLEventParseError.dataParseError
        }
    }
    
}
