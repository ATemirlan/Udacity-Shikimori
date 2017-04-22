//
//  RequestEngine.swift
//  Shikimori
//
//  Created by Temirlan on 25.03.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit
import AFNetworking
import ReachabilitySwift

class RequestEngine: NSObject {

    fileprivate let urls = Constants.WebMethods.self
    private let networkError = "Отсутствует интернет соединение"
    
    static let shared = RequestEngine()
    private override init() {}
    
    func login(nickname: String, password: String, completion: @escaping (_ code: Int, _ error: String?) -> Void) {
        addProgressHud()
        
        if isInternet() {
            let url = urls.login
            
            let params = [
                "nickname" : nickname,
                "password" : password
            ]
            
            AFHTTPSessionManager().post(url, parameters: params, progress: nil, success: { (dataTask, response) in
                
                if let info = response as? [String : String] {
                    User.current.nickname = nickname
                    User.current.token = info["api_access_token"]
                }
                
                self.removeProgressHud()
                completion(self.getCode(from: dataTask), nil)
            }) { (dataTask, err) in
                self.removeProgressHud()
                completion(self.getCode(from: dataTask), self.getCode(from: dataTask).errorCodeDescription())
            }
        } else {
            removeProgressHud()
            completion(700, networkError)
        }
    }
    
    func whoami(completion: @escaping (_ profile: Profile?) -> Void) {
        let url = urls.whoami
        
        manager().get(url, parameters: nil, progress: nil, success: { (dataTask, response) in
            var profile: Profile? = nil
            
            if let info = response as? [String : Any] {
                profile = Profile(with: info)
            }
            
            completion(profile)
        }) { (dataTask, err) in
            completion(nil)
        }
    }
    
    func getProfile(by id: String, completion: @escaping (_ profile: Profile?, _ error: String?) -> Void) {
        addProgressHud()
        
        if isInternet() {
            let url = urls.user.replacingOccurrences(of: "{userId}", with: id)
            
            manager().get(url, parameters: nil, progress: nil, success: { (dataTask, response) in
                var prof: Profile? = nil
                
                if let info = response as? [String : Any] {
                    if let obj = Profile(with: info) {
                        prof = obj
                    }
                }
                
                self.removeProgressHud()
                completion(prof, nil)
            }) { (dataTask, err) in
                self.removeProgressHud()
                completion(nil, self.getCode(from: dataTask).errorCodeDescription())
            }
        } else {
            removeProgressHud()
            completion(nil, networkError)
        }
    }
    
    func getGenres(completion: @escaping (_ genres: [Genre]?, _ error: String?) -> Void) {
        addProgressHud()
        
        if isInternet() {
            let url = urls.genres
            
            manager().get(url, parameters: nil, progress: nil, success: { (dataTask, response) in
                var genres = [Genre]()
                
                if let genreArray = response as? [[String : Any]] {
                    for genreInfo in genreArray {
                        if let genre = Genre(with: genreInfo) {
                            genres.append(genre)
                        }
                    }
                }
                
                completion(genres, nil)
                self.removeProgressHud()
            }) { (dataTask, err) in
                completion(nil, self.getCode(from: dataTask).errorCodeDescription())
                self.removeProgressHud()
            }
        } else {
            removeProgressHud()
            completion(nil, networkError)
        }
    }
    
    func searchAnimes(by title: String, completion: @escaping (_ result: [Anime]?, _ error: String?) -> Void) {
        let url = urls.animes.replacingOccurrences(of: "{page}", with: "1") + "&search=" + title
        retrieveAnimeList(url) { (animes, err) in
            completion(animes, err)
        }
    }
    
    func getMyListAnimes(with listType: String, completion: @escaping (_ result: [Anime]?, _ error: String?) -> Void) {
        let url = urls.myListAnimes.replacingOccurrences(of: "{mylist}", with: listType)
        retrieveAnimeList(url) { (animes, err) in
            completion(animes, err)
        }
    }

    func getAnimes(with filter: String?, at page: Int, completion: @escaping (_ result: [Anime]?, _ error: String?) -> Void) {
        let url = urls.animes.replacingOccurrences(of: "{page}", with: "\(page)") + (filter ?? "")
        retrieveAnimeList(url) { (animes, err) in
            completion(animes, err)
        }
    }
    
    func retrieveAnimeList(_ url: String, _ completion: @escaping (_ result: [Anime]?, _ error: String?) -> Void) {
        addProgressHud()
        
        if isInternet() {
            manager().get(url, parameters: nil, progress: nil, success: { (dataTask, response) in
                var animes = [Anime]()
                
                if let animeArr = response as? [[String : Any]] {
                    for animeInfo in animeArr {
                        if let anime = Anime(with: animeInfo, or: nil) {
                            animes.append(anime)
                        }
                    }
                }
                
                self.removeProgressHud()
                completion(animes, nil)
            }) { (dataTask, err) in
                self.removeProgressHud()
                completion(nil, self.getCode(from: dataTask).errorCodeDescription())
            }
        } else {
            removeProgressHud()
            completion(nil, networkError)
        }
    }
    
    func getAnime(by id: Int, withProgress: Bool, completion: @escaping (_ result: Anime?, _ error: String?) -> Void) {
        let url = urls.anime.replacingOccurrences(of: "{id}", with: String(id))
        
        if withProgress {
            addProgressHud()
        }
        
        if isInternet() {
            manager().get(url, parameters: nil, progress: nil, success: { (dataTask, response) in
                var anime: Anime? = nil
                
                if let animeArr = response as? [String : Any] {
                    if let anim = Anime(with: animeArr, or: nil) {
                        CoreDataStack.shared.save(anime: anim)
                        anime = anim
                    }
                }
                
                self.removeProgressHud()
                completion(anime, nil)
            }) { (dataTask, err) in
                self.removeProgressHud()
                completion(nil, self.getCode(from: dataTask).errorCodeDescription())
            }
        } else {
            removeProgressHud()
            completion(nil, networkError)
        }
    }
    
    func getSimilarAnimes(from animeId: Int, completion: @escaping (_ result: [Anime]?, _ error: String?) -> Void) {
        let url = urls.anime.replacingOccurrences(of: "{id}", with: String(animeId)).appending("/similar")
        addProgressHud()
        
        if isInternet() {
            manager().get(url, parameters: nil, progress: nil, success: { (dataTask, response) in
                var similars = [Anime]()
                
                if let result = response as? [[String : Any]] {
                    for animeInfo in result {
                        if let anime = Anime(with: animeInfo, or: nil) {
                            similars.append(anime)
                        }
                    }
                }
                
                self.removeProgressHud()
                completion(similars, nil)
            }) { (dataTask, err) in
                self.removeProgressHud()
                completion(nil, self.getCode(from: dataTask).errorCodeDescription())
            }
        } else {
            removeProgressHud()
            completion(nil, networkError)
        }
    }
    
    // Method is should not be used
    func getRate(userRateId: Int, completion: @escaping (_ error: String?) -> Void) {
        addProgressHud()
        
        if isInternet() {
            let url = urls.getRate.replacingOccurrences(of: "{id}", with: "\(userRateId)")
            
            manager().get(url, parameters: nil, progress: nil, success: { (dataTask, response) in
                
                self.removeProgressHud()
                completion(nil)
            }, failure: { (dataTask, err) in
                self.removeProgressHud()
                completion(self.getCode(from: dataTask).errorCodeDescription())
            })
        } else {
            self.removeProgressHud()
            completion(networkError)
        }
    }
    
    func add(anime animeId: Int, to list: String, completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
        addProgressHud()
        
        if isInternet() {
            let params = [
                "user_rate" : [
                    "user_id" : User.current.id!,
                    "target_id" : "\(animeId)",
                    "target_type" : "Anime",
                    "status" : list
                ]
            ]
            
            manager().post(urls.addToList, parameters: params, progress: nil, success: { (dataTask, response) in
                var success = false
                
                if (200...299).contains(self.getCode(from: dataTask)) {
                    success = true
                }
                
                self.removeProgressHud()
                completion(success, nil)
            }) { (dataTask, err) in
                self.removeProgressHud()
                completion(false, self.getCode(from: dataTask).errorCodeDescription())
            }
        } else {
            self.removeProgressHud()
            completion(false, networkError)
        }
    }
    
    func removeFromList(userRateId: Int, completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
        addProgressHud()
        
        if isInternet() {
            let url = urls.removeFromList.replacingOccurrences(of: "{id}", with: "\(userRateId)")
            
            manager().delete(url, parameters: nil, success: { (dataTask, response) in
                var success = false
                
                if (200...299).contains(self.getCode(from: dataTask)) {
                    success = true
                }
                
                self.removeProgressHud()
                completion(success, self.getCode(from: dataTask).errorCodeDescription())
            }, failure: { (dataTask, err) in
                self.removeProgressHud()
                completion(false, self.getCode(from: dataTask).errorCodeDescription())
            })
            
        } else {
            completion(false, networkError)
        }
    }
    
}

private extension RequestEngine {
    
    func manager() -> AFHTTPSessionManager {
        let manager = AFHTTPSessionManager()
        
        if let nickname = User.current.nickname, let token = User.current.token {
            manager.requestSerializer.setValue(nickname, forHTTPHeaderField: "X-User-Nickname")
            manager.requestSerializer.setValue(token, forHTTPHeaderField: "X-User-Api-Access-Token")
        }
        
        return manager
    }
    
    func isInternet() -> Bool {
        let reachability = Reachability()!
        return reachability.currentReachabilityStatus != Reachability.NetworkStatus.notReachable
    }
    
    func getCode(from dataTask: URLSessionDataTask?) -> Int {
        return (dataTask?.response as? HTTPURLResponse)?.statusCode ?? 0
    }
        
    func addProgressHud() {
        let window = UIApplication.shared.keyWindow!
        
        let dimView = UIView(frame: window.frame)
        dimView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        

        let progressView = UIView(frame: CGRect(x: window.center.x - 35, y: window.center.y - 35, width: 70, height: 70))
        progressView.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        progressView.layer.cornerRadius = 8
        progressView.clipsToBounds = true
        
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activity.frame.origin = CGPoint(x: progressView.frame.width / 2 - activity.frame.width / 2, y: progressView.frame.width / 2 - activity.frame.width / 2)
        activity.startAnimating()
        progressView.addSubview(activity)
        
        dimView.addSubview(progressView)
        dimView.tag = 771
        
        window.addSubview(dimView)
    }
    
    func removeProgressHud() {
        for view in UIApplication.shared.keyWindow!.subviews {
            if view.tag == 771 {
                view.removeFromSuperview()
            }
        }
    }

}
