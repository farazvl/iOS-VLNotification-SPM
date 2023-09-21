//
//  VLMobileConnectPayload.swift
//  VLAppleNotificationService
//
//  Created by Gaurav Vig on 09/01/23.
//

import Foundation

public struct VLMobileConnectPayload:Decodable {
    public let key:String?
    public let bitcode:Int?
}
