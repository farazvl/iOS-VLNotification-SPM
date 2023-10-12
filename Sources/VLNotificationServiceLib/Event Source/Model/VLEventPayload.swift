//
//  VLEventPayload.swift
//  VLAppleNotificationService
//
//  Created by Gaurav Vig on 09/01/23.
//

import Foundation

struct VLEventPayload:Decodable {
    let site:String?
    private let notificationType:String?
    let payload:String?
    var eventType:VLAppleNotificationType?
    let contentMetadata:ContentMetadata?
    
    private enum CodingKeys:String, CodingKey {
        case site, notificationType, payload
        case contentMetadata = "contentMeta"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.site = try? container.decodeIfPresent(String.self, forKey: .site)
        self.notificationType = try? container.decodeIfPresent(String.self, forKey: .notificationType)
        self.payload = try? container.decodeIfPresent(String.self, forKey: .payload)
        self.contentMetadata = try? container.decodeIfPresent(ContentMetadata.self, forKey: .contentMetadata)
        self.eventType = getNotificationType(notificationType: notificationType)
    }
    
    private func getNotificationType(notificationType:String?) -> VLAppleNotificationType {
        var eventType = VLAppleNotificationType.none
        if let notificationType, let appleNotificationType = VLAppleNotificationType(rawValue: notificationType) {
            eventType = appleNotificationType
        }
        return eventType
    }
}

extension VLEventPayload {
    struct ContentMetadata:Decodable {
        let contentId:String?
        let contentType:String?
        
        private enum CodingKeys:String, CodingKey {
            case contentId = "id"
            case contentType
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.contentId = try container.decodeIfPresent(String.self, forKey: .contentId)
            self.contentType = try container.decodeIfPresent(String.self, forKey: .contentType)
        }
    }
}
