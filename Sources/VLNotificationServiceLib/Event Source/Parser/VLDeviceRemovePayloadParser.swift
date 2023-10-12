//
//  VLDeviceRemovePayloadParser.swift
//  VLNotificationServiceLib
//
//  Created by Gaurav Vig on 01/08/23.
//

import Foundation

struct VLDeviceRemovePayloadParser:VLEventPayloadParser {
	typealias T = VLDeviceRemovePayload
	
	func parseEventPayload(from eventPayload:VLEventPayload) throws -> VLDeviceRemovePayload {
		guard let payload = eventPayload.payload, !payload.isEmpty,
			  let payloadData = payload.data(using: .utf8)
		else {
			throw VLEventParseError.deviceRemovePayloadParseError
		}

		return try parseDeviceRemovePayload(payloadData: payloadData)
	}
	
	private func parseDeviceRemovePayload(payloadData:Data) throws -> VLDeviceRemovePayload {
		do {
			let deviceRemove = try JSONDecoder().decode(VLDeviceRemovePayload.self, from: payloadData)
			return deviceRemove
		}
		catch {
			throw VLEventParseError.deviceRemovePayloadParseError
		}
	}
}
