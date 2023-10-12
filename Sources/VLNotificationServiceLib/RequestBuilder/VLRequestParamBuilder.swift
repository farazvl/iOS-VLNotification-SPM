//
//  VLRequestParamBuilder.swift
//  VLAppleNotificationService
//
//  Created by Gaurav Vig on 09/01/23.
//

import Foundation

protocol VLAPIRequestParamBuilder {}
extension VLAPIRequestParamBuilder {
    
    func getRequestParam(using tokenDetails:VLTokenDetails?) -> String {
        var requestParam = "/sse/v2/reader/non-persistent/viewlift"
        if let site = tokenDetails?.siteName {
            requestParam.append("/\(site)")
        }
        if let userId = tokenDetails?.userId {
            requestParam.append("/\(userId)")
        }
        return requestParam
    }
}
