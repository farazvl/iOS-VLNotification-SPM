//
//  VLGameHighlightsPayload.swift
//  VLNotificationServiceLib
//
//  Created by Gaurav Vig on 03/04/23.
//

import Foundation

public struct VLGameHighlightsPayload: Decodable {
    public let highlights: [VLGameHighlights]?
}

extension VLGameHighlightsPayload {
    public struct VLGameHighlights: Decodable {
        public let id: String?
        public let title: String?
        public let gist: VLContentMetadata?
    }
}

extension VLGameHighlightsPayload.VLGameHighlights {
    public struct VLContentMetadata: Decodable {
        public let id: String?
        public let site: String?
        public let permalink: String?
        public let title: String?
        public let description: String?
        public let imageGist: VLImageGist?
        public let contentType: String?
        public let languageCode: String?
        public let timezone: String?
    }
}

extension VLGameHighlightsPayload.VLGameHighlights.VLContentMetadata {
    public struct VLImageGist: Decodable {
        public let _32x9: String?
        public let _16x9: String?
        public let _4x3: String?
        public let _3x4: String?
        public let _9x16: String?
        public let _1x1: String?
    }
}
//{
//  "highlights": [
//    {
//      "id": "e8d3e6ae-0018-47dd-b8da-746f06ce2eb2",
//      "title": "top score",
//      "gist": {
//        "id": "e8d3e6ae-0018-47dd-b8da-746f06ce2eb2",
//        "site": "vw",
//        "permalink": "/videos/highlight",
//        "title": "top score",
//        "description": "top score",
//        "imageGist": {
//          "_32x9": null,
//          "_16x9": "https://v-test.viewlift.com/Renditions/20230221/Adsatul4/thumbnail/large/Adsatul4_1.0000002.jpg",
//          "_4x3": null,
//          "_3x4": null,
//          "_9x16": null,
//          "_1x1": null
//        },
//        "primaryCategory": {},
//        "contentType": "VIDEO",
//        "languageCode": "default",
//        "timezone": "America/New_York",
//        "featuredTag": {}
//      }
//    }
//  ]
//}
