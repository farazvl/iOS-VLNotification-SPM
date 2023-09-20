//
//  VLEventSourceObject.swift
//  VLAppleNotificationService
//
//  Created by Gaurav Vig on 10/01/23.
//

import Foundation

struct VLEventSourceObject:Decodable {
    let payload:String?
    let heartbeat:Double?
    
    private enum CodingKeys:String, CodingKey {
        case payload, heartbeat
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.payload = try? container.decodeIfPresent(String.self, forKey: .payload)
        self.heartbeat = try? container.decodeIfPresent(Double.self, forKey: .heartbeat)
    }
}
