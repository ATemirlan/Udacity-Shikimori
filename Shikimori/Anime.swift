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
    var userRateId: Int?
    var previewScreenshots: [URL?]?
    var originalScreenshots: [URL?]?
    
    init?(with animeInfo: [String : Any]?, or localAnime: LocalAnime?) {
        
        if let info = animeInfo {
            if let id = info["id"] as? Int {
                self.id = id
            }
            
            if let name = info["name"] as? String {
                self.name = name
            }
            
            if let russianName = info["russian"] as? String {
                self.russianName = russianName
            }
            
            if let kind = info["kind"] as? String {
                self.kind = kind
            }
            
            if let genres = info["genres"] as? [[String : Any]] {
                var genresString = ""
                
                for genre in genres {
                    if let genreTitle = genre["russian"] as? String {
                        genresString += genreTitle + " "
                    }
                }
                
                self.genres = genresString
            }
            
            if let status = info["status"] as? String {
                self.status = status
            }
            
            if let description = info["description_html"] as? String {
                self.descript = description.htmlAttributedString()?.string
                
                if let _ = self.descript {
                    if self.descript!.hasSuffix("\n") {
                        let endIndex = self.descript!.index(self.descript!.endIndex, offsetBy: -2)
                        self.descript = self.descript!.substring(to: endIndex)
                    }
                }
            }
            
            if let score = info["score"] as? String {
                self.score = Float(score)
            }
            
            if let episodes = info["episodes"] as? Int {
                self.episodes = episodes
            }
            
            if let episodes_aired = info["episodes_aired"] as? Int {
                self.episodes_aired = episodes_aired
            }
            
            if let imageArr = info["image"] as? [String : String] {
                if let original = imageArr["original"] {
                    self.imageUrl = URL(string: Constants.WebMethods.baseURL + original)
                } else if let preview = imageArr["preview"] {
                    self.imageUrl = URL(string: Constants.WebMethods.baseURL + preview)
                }
            }
            
            if let screenshotsArr = info["screenshots"] as? [[String : String]] {
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
            
            if let user_rate = info["user_rate"] as? [String : Any] {
                if let id = user_rate["id"] as? Int {
                    self.userRateId = id
                }
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            if let aired = info["aired_on"] as? String {
                self.aired_on = formatter.date(from: aired)
            }
            
            if let released = info["released_on"] as? String {
                self.released_on = formatter.date(from: released)
            }
        } else if let local = localAnime {
            self.id = Int(local.id!)
            self.kind = local.kind
            self.genres = local.genres
            self.name = local.name
            self.russianName = local.russianName
            self.status = local.status
            self.descript = local.descript
            self.score = local.score
            
            self.aired_on = local.aired_on as Date?
            self.released_on = local.released_on as Date?
            
            if let _ = local.episodes {
                self.episodes = Int(local.episodes!)
            }
            
            if let _ = local.episodes_aired {
                self.episodes_aired = Int(local.episodes_aired!)
            }
            
            if let _ = local.imageUrl {
                self.imageUrl = URL(string: local.imageUrl!)
            }
        }
        
        super.init()
    }
    
}
