//
//  VLGameStatePayload.swift
//  VLNotificationServiceLib
//
//  Created by Gaurav Vig on 21/02/23.
//

import Foundation

public struct VLGameStatePayload:Decodable {
    public let currentGameState:String?
    public let gameId:String?
    public let gameStates:VLGameStates?
    
    private enum CodingKeys:String, CodingKey {
        case currentGameState = "currentState"
        case gameId = "id"
        case gameStates = "states"
    }
}

extension VLGameStatePayload {
    public struct VLGameStates:Decodable {
        public let defaultState:VLGameStateInfo?
        public let preState:VLGameStateInfo?
        public let postState:VLGameStateInfo?
        public let liveState:VLGameStateInfo?
        public let endState:VLGameStateInfo?
        
        private enum CodingKeys:String, CodingKey {
            case defaultState = "default"
            case preState = "pre"
            case postState = "post"
            case liveState = "live"
            case endState = "end"
        }
    }
}

extension VLGameStatePayload.VLGameStates {
    public struct VLGameStateInfo:Decodable {
        public let startDateTime:Double?
        public let endDateTime:Double?
    }
}
