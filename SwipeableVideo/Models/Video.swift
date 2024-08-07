//
//  Video.swift
//  SwipeableVideo
//
//  Created by Rizki Siraj on 06/08/24.
//

import Foundation

struct Video: Identifiable, Codable {
    var id: String?
    let title: String
    let description: String
    let videoURL: String
}


extension Video {
    static let videosDummy = [Video(id: "0", title: "Adit", description: "brengsek", videoURL: "https://archive.org/download/four_days_of_gemini_4/four_days_of_gemini_4_512kb.mp4"), Video(id: "1", title: "Azis", description: "brengsek", videoURL: "https://archive.org/download/four_days_of_gemini_4/four_days_of_gemini_4_512kb.mp4"), Video(id: "2", title: "Azis", description: "brengsek", videoURL: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4"), Video(id: "3", title: "Azis", description: "brengsek", videoURL: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4")]
}
