//
//  Constants.swift
//  Shikimori
//
//  Created by Temirlan on 25.03.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import Foundation

struct Constants {
    
    struct WebMethods {
        static let baseURL = "https://shikimori.org/"
        static let topics = WebMethods.baseURL + "api/topics?forum={forum}&limit={limit}&page={page}"
        static let animes = WebMethods.baseURL + "api/animes?censored=true&limit=50&page={page}"
        static let anime = WebMethods.baseURL + "api/animes/{id}"
        static let genres = WebMethods.baseURL + "api/genres"
        static let login = WebMethods.baseURL + "api/access_token"
        static let whoami = WebMethods.baseURL + "api/users/whoami"
        static let user = WebMethods.baseURL + "api/users/{userId}"
        static let myListAnimes = WebMethods.baseURL + "api/animes?censored=true&limit=10&page=1&order=random&mylist={mylist}"
    }
    
    struct MyList {
        static let planned = "planned"
        static let watching = "watching"
        static let completed = "completed"
        static let on_hold = "on_hold"
        static let dropped = "dropped"
    }
    
    struct Forum {
        static let all = "all"
        static let animanga = "animanga"
        static let vn = "vn"
        static let games = "games"
        static let site = "site"
        static let offtopic = "offtopic"
        static let news = "news"
        static let reviews = "reviews"
        static let contests = "contests"
        static let my_clubs = "my_clubs"
        static let clubs = "clubs"
    }
    
    struct Error {
        
    }
    
    struct SystemColor {
        static let navBarColor = UIColor.init(red: 52.0 / 255.0, green: 52.0 / 255.0, blue: 52.0 / 255.0, alpha: 1.0)
        static let blue = UIColor.init(red: 29.0 / 255.0, green: 110.0 / 255.0, blue: 218.0 / 255.0, alpha: 1.0)
    }
}
