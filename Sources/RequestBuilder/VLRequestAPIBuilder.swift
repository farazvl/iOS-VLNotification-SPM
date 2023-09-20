//
//  VLRequestAPIBuilder.swift
//  VLNotificationServiceLib
//
//  Created by Gaurav Vig on 30/01/23.
//

import Foundation

protocol VLRequestAPIBuilder:AnyObject {}
extension VLRequestAPIBuilder {
    
    func getConnectionUrlString() -> String? {
        var filePath:String?
        let classBundle = Bundle(for: type(of: self))
        if let classBundlePath = classBundle.path(forResource: "VLAppleNotificationService", ofType: "bundle"), let bundle = Bundle(path: classBundlePath) {
            filePath = bundle.path(forResource: "Configuration", ofType: "plist")
        }
        if filePath == nil {
            guard let bundle = Bundle(identifier: "com.viewlift.notificationService") else {
                return nil
            }
            filePath = bundle.path(forResource: "Configuration", ofType: "plist")
        }
        guard let filePath else { return nil }
        if let configData = try? Data(contentsOf: URL(fileURLWithPath: filePath)), let configuration = try? PropertyListDecoder().decode(VLConfiguration.self, from: configData),
           let connectionUrlString = configuration.connectionUrl {
           return connectionUrlString
        }
        return nil
    }
}
