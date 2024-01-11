//
//  File.swift
//  
//
//  Created by NexG on 11/01/24.
//

import Foundation

public struct VLChampionsStatusPayload: Decodable {
    let championsData: String?
    let golfStats: GolfStats?
}

public struct GolfStats: Decodable {
    
    let currentRound: GolfStatRoundName?
    let currentStatusIdentifier: GameStateMiamiLeaderboard?
    let eventStatus: GameStateMiamiLeaderboard?
    let roundStates: [GolfStatRound]?
    
}

public struct GolfStatRound: Decodable {
    
    let round: GolfStatRoundName?
    let statusIdentifier: GameStateMiamiLeaderboard?
    
}

public enum GameStateMiamiLeaderboard: String, Codable, CaseIterable{
    case resultMode = "resultMode"
    case buildUp = "buildUp"
    case liveMode = "liveMode"
    case matchAnnounced = "matchAnnounced"
    case finalMode = "finalMode"
    case notApplicable = "notApplicable"
}

public enum GolfStatRoundName: Int, Codable, CaseIterable{
    case noRound = 0
    case quarterFinal = 1
    case semiFinal = 2
    case finalRound = 3
    
    var roundNumber: String {
        get {
            switch self {
            case.noRound:
                return "0"
            case .quarterFinal:
                return "1"
            case .semiFinal:
                return "2"
            case .finalRound:
                return "3"
            }
        }
    }
}
