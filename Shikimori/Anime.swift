//
//  Anime.swift
//  Shikimori
//
//  Created by Temirlan on 25.03.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import SwiftyJSON

struct Anime {
    
    var id: Int
    var episodes: Int?
    var episodes_aired: Int?
    var imageUrl: URL?
    var kind: String?
    var genres: String?
    var name: String?
    var russianName: String?
    var released_on: Date?
    var aired_on: Date?
    var status: String?
    var descript: String?
    var score: Float?
    var userRateId: Int?
    var previewScreenshots: [URL?]?
    var originalScreenshots: [URL?]?
    
    init(with json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].string
        self.russianName = json["russian"].string
        self.episodes = json["episodes"].int
        self.episodes_aired = json["episodes_aired"].int
        self.kind = json["kind"].string
        self.status = json["status"].string
//        self.aired_on = json["aired_on"].string
//        self.released_on = json["released_on"].string
        
        if let urlStr = json["image"]["original"].string {
            self.imageUrl = URL(string: (ApiRouter.baseUrl + urlStr).replacingOccurrences(of: "api//", with: ""))
        }
    }
    
}

