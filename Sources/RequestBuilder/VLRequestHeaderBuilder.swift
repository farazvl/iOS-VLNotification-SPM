//
//  VLRequestHeaderBuilder.swift
//  VLAppleNotificationService
//
//  Created by Gaurav Vig on 09/01/23.
//

import Foundation

struct VLRequestHeaderBuilder {
    
    var Authorization:String?

    func getRequestHeader() -> [String:String] {
        var requestParam:[String:String] = [:]
        let mirror = Mirror(reflecting: self)
        mirror.children.forEach { child in
            if let label = child.label, let value = child.value as? String {
                requestParam[label] = value
            }
        }
        return requestParam
    }
}
