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
                User.current.token = json["api_access_token"] as? String
            }
            
            completion(response.error)
        }
    }

    func getAnimes(with filter: Filter?, completion: @escaping (_ result: [Anime]?, _ error: String?) -> Void) {
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
    
//    func getAnime(by id: Int, withProgress: Bool, completion: @escaping (_ result: Anime?, _ error: String?) -> Void) {
//        let url = urls.anime.replacingOccurrences(of: "{id}", with: String(id))
//
//        manager().get(url, parameters: nil, progress: nil, success: { (dataTask, response) in
//            var anime: Anime? = nil
//
//            self.removeProgressHud()
//            completion(anime, nil)
//        }) { (dataTask, err) in
//            self.removeProgressHud()
//            completion(nil, self.getCode(from: dataTask).errorCodeDescription())
//        }
//    }
    
}
