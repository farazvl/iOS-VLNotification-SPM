//
//  VLEventSourceParser.swift
//  VLAppleNotificationService
//
//  Created by Gaurav Vig on 10/01/23.
//

import Foundation

struct VLEventSourceParser {

    func parse(data: Data) throws -> VLEventSourceObject {
        do {
            let eventSourceObj = try JSONDecoder().decode(VLEventSourceObject.self, from: data)
            return eventSourceObj
        }
        catch {
            throw VLEventParseError.dataParseError
        }
    }
}
