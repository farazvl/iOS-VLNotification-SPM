//
//  VLEventPayloadParser.swift
//  VLAppleNotificationService
//
//  Created by Gaurav Vig on 10/01/23.
//

import Foundation

protocol VLEventPayloadParser {
    associatedtype T
    func parseEventPayload(from eventPayload:VLEventPayload) throws -> T
}
