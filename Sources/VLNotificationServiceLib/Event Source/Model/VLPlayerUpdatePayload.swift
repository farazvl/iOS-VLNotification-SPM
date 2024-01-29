//
//  VLPlayerUpdatePayload.swift
//
//
//  Created by Japneet Singh on 22/01/24.
//

import Foundation

public struct VLPlayerUpdatePayload: Codable {
    
    public let holeNumber: Int?
    public let position: String?
    public let viewliftPlayerId: String?
    public let playerName: String?
    public let playerId: Int?
    
    public var contentId: String?
    public var contentType: String?
    
    internal mutating func updateContentMetadata(contentMetadata:VLEventPayload.ContentMetadata) {
        self.contentId = contentMetadata.contentId
        self.contentType = contentMetadata.contentType
    }
}
