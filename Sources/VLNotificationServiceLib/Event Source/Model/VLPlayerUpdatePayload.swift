//
//  VLPlayerUpdatePayload.swift
//
//
//  Created by Japneet Singh on 22/01/24.
//

import Foundation

public struct VLPlayerUpdatePayload: Codable {
    
    public let playerData: PlayerData?
    public let contentMetadata: ContentMetadata?
    
    private enum CodingKeys: String, CodingKey {
        case playerData = "payload"
        case contentMetadata = "contentMeta"
    }
    
    public struct PlayerData: Codable {
        public let holeNumber: Int?
        public let position: String?
        public let playerId: String?
        public let playerName: String?
        
        private enum CodingKeys: String, CodingKey {
            case holeNumber
            case position
            case playerId = "viewliftPlayerId"
            case playerName
        }
    }
    
    public struct ContentMetadata:Codable {
        let contentId:String?
        let contentType:String?
        
        private enum CodingKeys:String, CodingKey {
            case contentId = "id"
            case contentType
        }
    }
}
