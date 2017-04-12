//
//  Anime.swift
//  Shikimori
//
//  Created by Temirlan on 25.03.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class Anime: NSObject {
    
    var id: Int?
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
    var previewScreenshots: [URL?]?
    var originalScreenshots: [URL?]?
    
    init?(with animeInfo: [String : Any]) {
        
        if let id = animeInfo["id"] as? Int {
            self.id = id
        }
        
        if let name = animeInfo["name"] as? String {
            self.name = name
        }
        
        if let russianName = animeInfo["russian"] as? String {
            self.russianName = russianName
        }
        
        if let kind = animeInfo["kind"] as? String {
            self.kind = kind
        }
        
        if let genres = animeInfo["genres"] as? [[String : Any]] {
            var genresString = ""
            
            for genre in genres {
                if let genreTitle = genre["russian"] as? String {
                    genresString += genreTitle + " "
                }
            }
            
            self.genres = genresString
        }
        
        if let status = animeInfo["status"] as? String {
            self.status = status
        }
        
        if let description = animeInfo["description_html"] as? String {
            self.descript = description.htmlAttributedString()?.string
            
            if let _ = self.descript {
                if self.descript!.hasSuffix("\n") {
                    let endIndex = self.descript!.index(self.descript!.endIndex, offsetBy: -2)
                    self.descript = self.descript!.substring(to: endIndex)
                }
            }
        }
        
        if let score = animeInfo["score"] as? String {
            self.score = Float(score)
        }
        
        if let episodes = animeInfo["episodes"] as? Int {
            self.episodes = episodes
        }
        
        if let episodes_aired = animeInfo["episodes_aired"] as? Int {
            self.episodes_aired = episodes_aired
        }
        
        if let imageArr = animeInfo["image"] as? [String : String] {
            if let original = imageArr["original"] {
                self.imageUrl = URL(string: Constants.WebMethods.baseURL + original)
            } else if let preview = imageArr["preview"] {
                self.imageUrl = URL(string: Constants.WebMethods.baseURL + preview)
            }
        }
        
        if let screenshotsArr = animeInfo["screenshots"] as? [[String : String]] {
            var previewScreens = [URL?]()
            var originalScreens = [URL?]()
            
            for screen in screenshotsArr {
                if let original = screen["original"] {
                    originalScreens.append(URL(string: Constants.WebMethods.baseURL + original))
                }
                
                if let preview = screen["preview"] {
                    previewScreens.append(URL(string: Constants.WebMethods.baseURL + preview))
                }
            }
            
            self.previewScreenshots = previewScreens
            self.originalScreenshots = originalScreens
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let aired = animeInfo["aired_on"] as? String {
            self.aired_on = formatter.date(from: aired)
        }
        
        if let released = animeInfo["released_on"] as? String {
            self.released_on = formatter.date(from: released)
        }
        
        super.init()
    }
    
    func getAll() {
//        print(id)
//        print(episodes)
//        print(episodes_aired)
//        print(imageUrl)
//        print(name)
//        print(russianName)
//        print(kind)
//        print(genres)
//        print(released_on)
//        print(aired_on)
//        print(status)
//        print(descript)
//        print(score)
    }
}
