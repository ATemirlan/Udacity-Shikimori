//
//  ApiRouter.swift
//  Shikimori
//
//  Created by Темирлан Алпысбаев on 12/20/17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import Alamofire

protocol EndPoint {
    var url: String { get set }
    var method: HTTPMethod { get }
    var successCodes: CountableClosedRange<Int> { get }
    var failureCodes: [Int] { get }
}

struct ApiRouter {
    
    static let baseUrl = "https://shikimori.org/api/"
    
    static func url(_ path: String) -> String {
        return baseUrl + path
    }
    
    static func base(_ path: String, replacingParams: [String : String], urlParams: [String : String?]) -> String {
        var url = self.url(path)// + "?"
        
        let _ = replacingParams.map { url = url.replacingOccurrences(of: $0.key, with: $0.value) }
        
        if urlParams.count > 0 {
            url += "?"
            
            let _ = urlParams.map {
                if let value = $0.value {
                    url += $0.key + "=" + value + "&"
                }
            }
            
            url = String(url[..<url.index(before: url.endIndex)])
        }
        
        return url
    }
    
    struct Login: EndPoint {
        var url: String = "access_token"
        var method: HTTPMethod = .post
        var successCodes: CountableClosedRange<Int> = 200...299
        var failureCodes = [422]
    }
    
    struct AnimeList: EndPoint {
        var url: String = "animes"
        var method: HTTPMethod = .get
        var successCodes: CountableClosedRange<Int> = 200...299
        var failureCodes = [422]
    }
    
}
