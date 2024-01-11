//
//  File.swift
//
//
//  Created by NexG on 11/01/24.
//

import Foundation

public struct VLChampionsStatusPayload: Decodable {
    public let championsData: VLGolfStatsChampionsData?
    public let golfStats: GolfStats?
}

public struct VLGolfStatsChampionsData: Decodable {
    public let id: String?
}

public struct GolfStats: Decodable {
    
    public let currentRound: GolfStatRoundName?
    public let currentStatusIdentifier: GameStateMiamiLeaderboard?
    public let eventStatus: GameStateMiamiLeaderboard?
    public let roundStates: [GolfStatRound]?
    
}

public struct GolfStatRound: Decodable {
    
    public let round: GolfStatRoundName?
    public let statusIdentifier: GameStateMiamiLeaderboard?
    
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
    
    public var roundNumber: String {
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
