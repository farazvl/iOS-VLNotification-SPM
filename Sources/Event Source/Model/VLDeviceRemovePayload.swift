//
//  VLDeviceRemovePayload.swift
//  VLNotificationServiceLib
//
//  Created by Gaurav Vig on 01/08/23.
//

import Foundation

public struct VLDeviceRemovePayload: Decodable {
	public let deviceIds: [String]?
}
