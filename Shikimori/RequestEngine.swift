//
//  RequestEngine.swift
//  Shikimori
//
//  Created by Темирлан Алпысбаев on 12/20/17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import Alamofire
import SwiftyJSON

class RequestEngine: BaseRequestEngine {
    
    static let shared = RequestEngine()
    
    private override init() {}
    
    func login(nickname: String, password: String, completion: @escaping (_ error: String?) -> Void) {
        let params = [
            "nickname" : nickname,
            "password" : password
        ]
        
        apiRequest(route: ApiRouter.Login(), params: params) { (response) in
            if response.result, let json = response.json {
                User.current.nickname = nickname
                User.current.token = json["api_access_token"].stringValue
            }
            
            completion(response.error)
        } 
    }

    func getAnimes(with filter: Filter?, completion: @escaping (_ animes: [Anime]?, _ error: String?) -> Void) {
        apiRequest(route: ApiRouter.AnimeList(), urlParams: filter?.toDict() ?? [:], params: nil) { (response) in
            guard response.result, let json = response.json else {
                completion(nil, response.error)
                return
            }
            
            var list = [Anime]()
            
            for animeJSON in json.arrayValue {
                list.append(Anime(with: animeJSON))
            }
            
            completion(list.count > 0 ? list : nil, response.error)
        }
    }
    
    func getGenres(isAnime: Bool, completion: @escaping (_ genres: [Genre]?) -> Void) {
        apiRequest(route: ApiRouter.Genres()) { (response) in
            guard response.result, let json = response.json else {
                completion(nil)
                return
            }
            
            var genres = [Genre]()
            
            for genreJSON in json.arrayValue {
                if let genre = Genre(with: genreJSON) {
                    genres.append(genre)
                }
            }
            
            completion(genres.filter { $0.kind == (isAnime ? "anime" : "manga") })
        }
    }
    
}
