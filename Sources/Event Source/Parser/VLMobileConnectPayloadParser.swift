//
//  VLMobileConnectPayloadParser.swift
//  VLAppleNotificationService
//
//  Created by Gaurav Vig on 10/01/23.
//

import Foundation

struct VLMobileConnectPayloadParser:VLEventPayloadParser {
    typealias T = VLMobileConnectPayload
    
    func parseEventPayload(from eventPayload:VLEventPayload) throws -> VLMobileConnectPayload {
        guard let payload = eventPayload.payload, !payload.isEmpty,
              let payloadData = payload.data(using: .utf8)
        else {
            throw VLEventParseError.mobileConnectPayloadParseError
        }

        return try parseMobileConnectPayload(payloadData: payloadData)
    }
    
    private func parseMobileConnectPayload(payloadData:Data) throws -> VLMobileConnectPayload {
        do {
            let mobileConnect = try JSONDecoder().decode(VLMobileConnectPayload.self, from: payloadData)
            return mobileConnect
        }
        catch {
            throw VLEventParseError.mobileConnectPayloadParseError
        }
    }
}
