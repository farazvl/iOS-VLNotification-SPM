//
//  VLAppleNotificationServiceEnums.swift
//  
//
//  Created by Gaurav Vig on 09/01/23.
//

import Foundation

public enum VLAppleNotificationType: String {
    case mobileSignIn = "USER_TV_CONNECT_WITH_MOBILE"
    case scoreUpdate = "GAME_LIVE_SCORE"
    case gameState = "GAME_STATE_CHANGE"
    case gameHighlights = "GAME_HIGHLIGHTS_UPDATED"
	case deviceRemoved = "USER_DEVICE_REMOVED"
    case championTournamentStatus = "CHAMPION_TOURNAMENT_STATUS_UPDATE"
    case none
}
