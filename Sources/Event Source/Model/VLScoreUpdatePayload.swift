//
//  VLScoreUpdatePayload.swift
//  VLAppleNotificationService
//
//  Created by Gaurav Vig on 10/01/23.
//

import Foundation

public struct VLScoreUpdatePayload:Decodable {
    
    public enum GameStatus:String {
        case inprogress = "inprogress"
        case notStarted = "notStarted"
        case completed = "completed"
        
        static func getGameStatus(status:String) -> GameStatus {
            var gameState = GameStatus.notStarted
            switch status.lowercased() {
            case "inprogress", "halftime":
                gameState = .inprogress
            case "notstarted", "open":
                gameState = .notStarted
            case "completed":
                gameState = .completed
            default:
                break
            }
            return gameState
        }
    }
    
    @frozen public enum GamePeriod {
        case firstQuarter
        case secondQuarter
        case thirdQuarter
        case fourthQuarter
        case firstHalf
        case secondHalf
        case thirdHalf
        case fourthHalf
        
        static func getGamePeriod(type:String, number:Int) -> GamePeriod? {
            var gamePeriod:GamePeriod? = nil
            switch type.lowercased() {
            case "quarter":
                switch number {
                case 1:
                    gamePeriod = .firstQuarter
                case 2:
                    gamePeriod = .secondQuarter
                case 3:
                    gamePeriod = .thirdQuarter
                case 4:
                    gamePeriod = .fourthQuarter
                default:
                    break
                }
            case "half":
                switch number {
                case 1:
                    gamePeriod = .firstHalf
                case 2:
                    gamePeriod = .secondHalf
                case 3:
                    gamePeriod = .thirdHalf
                case 4:
                    gamePeriod = .fourthHalf
                default:
                    break
                }
            default:
                break
            }
            return gamePeriod
        }
    }
    
    public let homePoint:Int?
    public let awayPoint:Int?
    private let status:String?
    public let type:String?
    public let number:Int?
    public var gameStatus:GameStatus?
    public var gamePeriod:GamePeriod?
    
    public var contentId:String?
    public var contentType:String?
    
    private enum CodingKeys:String, CodingKey {
        case homePoint, awayPoint, status, type, number
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.homePoint = try? container.decodeIfPresent(Int.self, forKey: .homePoint)
        self.awayPoint = try? container.decodeIfPresent(Int.self, forKey: .awayPoint)
        self.status = try? container.decodeIfPresent(String.self, forKey: .status)
        self.type = try? container.decodeIfPresent(String.self, forKey: .type)
        self.number = try? container.decodeIfPresent(Int.self, forKey: .number)
        setGameStatus()
        setGamePeriod()
    }

    private mutating func setGameStatus() {
        if let status {
            self.gameStatus = GameStatus.getGameStatus(status: status)
        }
    }
    
    private mutating func setGamePeriod() {
        if let type, let number {
            self.gamePeriod = GamePeriod.getGamePeriod(type: type, number: number)
        }
    }
    
    internal mutating func updateContentMetadata(contentMetadata:VLEventPayload.ContentMetadata) {
        self.contentId = contentMetadata.contentId
        self.contentType = contentMetadata.contentType
    }
    
    public func getLocalisedGameStatusValue() -> String? {
        return self.gameStatus?.rawValue
    }
}
