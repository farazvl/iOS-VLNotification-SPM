//
//  VLTokenDetails.swift
//  VLAppleNotificationService
//
//  Created by Gaurav Vig on 09/01/23.
//

import Foundation

struct VLTokenDetails:Decodable {
    var userId:String?
    var siteName:String?
    var siteId:String?
    var deviceId:String?

    private enum CodingKeys:String, CodingKey {
        case userId, siteId, deviceId
        case siteName = "site"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decodeIfPresent(String.self, forKey: .userId)
        self.siteId = try container.decodeIfPresent(String.self, forKey: .siteId)
        self.deviceId = try container.decodeIfPresent(String.self, forKey: .deviceId)
        self.siteName = try container.decodeIfPresent(String.self, forKey: .siteName)
    }
    
    init(with userId:String?, siteName:String?, siteId:String?, deviceId:String) {
        self.userId = userId
        self.siteId = siteId
        self.deviceId = deviceId
        self.siteName = siteName
    }
}
