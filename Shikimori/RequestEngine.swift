//
//  RequestEngine.swift
//  Shikimori
//
//  Created by Temirlan on 25.03.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit
import AFNetworking

class RequestEngine: NSObject {

    fileprivate let urls = Constants.WebMethods.self
    
    static let shared = RequestEngine()
    private override init() {}
    
    func getGenres(completion: @escaping (_ genres: [Genre]?, _ error: String?) -> Void) {
        addProgressHud()
        let url = urls.genres
        
        AFHTTPSessionManager().get(url, parameters: nil, progress: nil, success: { (dataTask, response) in
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
            completion(nil, nil)
            self.removeProgressHud()
        }
    }
    
    func searchAnimes(by title: String, completion: @escaping (_ result: [Anime]?, _ error: String?) -> Void) {
        let url = urls.animes.replacingOccurrences(of: "{page}", with: "1") + "&search=" + title
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
        
        AFHTTPSessionManager().get(url, parameters: nil, progress: nil, success: { (dataTask, response) in
            var animes = [Anime]()
            
            if let animeArr = response as? [[String : Any]] {
                for animeInfo in animeArr {
                    if let anime = Anime(with: animeInfo) {
                        animes.append(anime)
                    }
                }
            }
            
            self.removeProgressHud()
            completion(animes, nil)
        }) { (dataTask, err) in
            self.removeProgressHud()
            completion(nil, nil)
        }
    }
    
    func getAnime(by id: Int, withProgress: Bool, completion: @escaping (_ result: Anime?, _ error: String?) -> Void) {
        let url = urls.anime.replacingOccurrences(of: "{id}", with: String(id))
        
        if withProgress {
            addProgressHud()
        }
        
        AFHTTPSessionManager().get(url, parameters: nil, progress: nil, success: { (dataTask, response) in
            var anime: Anime? = nil

            if let animeArr = response as? [String : Any] {
                anime = Anime(with: animeArr)
            }
            
            self.removeProgressHud()
            completion(anime, nil)
        }) { (dataTask, err) in
            self.removeProgressHud()
            completion(nil, nil)
        }
    }
    
    func getSimilarAnimes(from animeId: Int, completion: @escaping (_ result: [Anime]?, _ error: String?) -> Void) {
        let url = urls.anime.replacingOccurrences(of: "{id}", with: String(animeId)).appending("/similar")
        addProgressHud()
        
        AFHTTPSessionManager().get(url, parameters: nil, progress: nil, success: { (dataTask, response) in
            var similars = [Anime]()
            
            if let result = response as? [[String : Any]] {
                for animeInfo in result {
                    if let anime = Anime(with: animeInfo) {
                        similars.append(anime)
                    }
                }
            }
            
            self.removeProgressHud()
            completion(similars, nil)
        }) { (dataTask, err) in
            self.removeProgressHud()
            completion(nil, nil)
        }
    }
    
    func loadPhoto(with url: URL, completion: @escaping(_ path: URL?, _ error: String?) -> Void) {
        let request = URLRequest(url: url)
        
        AFHTTPSessionManager().downloadTask(with: request, progress: nil, destination: { (path, response) -> URL in
            return path
        }) { (response, path, error) in
            completion(nil, "error")
        }.resume()
    }
    
}

private extension RequestEngine {
    
    func getCode(from dataTask: URLSessionDataTask?) -> Int {
        return (dataTask?.response as? HTTPURLResponse)?.statusCode ?? 0
    }
    
    func getErrorString(error: Error) -> String? {

        return nil
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
