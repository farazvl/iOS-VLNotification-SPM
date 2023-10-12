//
//  VLRequestQueryParams.swift
//  VLNotificationServiceLib
//
//  Created by Gaurav Vig on 24/02/23.
//

import Foundation

struct VLRequestQueryParams {
    
#if os(tvOS)
    let device = "APPLETV"
#else
    let device = "IOS"
#endif
    
    func getQueryParams() -> [URLQueryItem] {
        var queryItems:[URLQueryItem] = []
        let mirror = Mirror(reflecting: self)
        mirror.children.forEach { child in
            if let label = child.label, let value = child.value as? String {
                queryItems.append(URLQueryItem(name: label, value: value))
            }
        }
        return queryItems
    }
}
