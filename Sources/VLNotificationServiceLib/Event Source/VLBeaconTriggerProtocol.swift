//
//  VLBeaconTriggerProtocol.swift
//  VLNotificationServiceLib
//
//  Created by NEXGEN on 21/06/23.
//

import Foundation
//@_implementationOnly import VLBeaconLib

internal protocol VLBeaconEventProtocols{
    func triggerUserBeaconEvent(eventData: VLEventPayload?, authorizationToken: String)
}

extension VLBeaconEventProtocols {
    
    func triggerUserBeaconEvent(eventData: VLEventPayload?, authorizationToken: String) {
        
//        let userEventBody = UserBeaconEventStruct(eventName: .custom(eventName: "notification-service"), source: "VLAppleNotificationService", eventData: AuthenticationPayload(additionalData: ["notificationType" : eventData?.eventType?.rawValue ?? "", "contentType":eventData?.contentMetadata?.contentType ?? "", "payload" : eventData?.payload ?? "" ]))
//        
//        VLBeacon.sharedInstance.authorizationToken = authorizationToken
//        VLBeacon.sharedInstance.triggerBeaconEvent(userEventBody)
    }
    
}
