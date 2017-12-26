//
//  BaseRequestEngine.swift
//  Shikimori
//
//  Created by Темирлан Алпысбаев on 12/20/17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import Alamofire
import SwiftyJSON
import AlamofireImage
import ReachabilitySwift

class BaseRequestEngine {
    
    private func headers() -> [String : String] {
        return [
            "X-User-Nickname": User.current.nickname ?? "",
            "X-User-Api-Access-Token": User.current.token ?? ""
        ]
    }
    
    private func falseResponse(url: String, _ message: String = Constants.Messages.unknownError) -> ApiResponse {
        let response = ApiResponse(result: false, code: -1, error: message, url: url, json: nil)
        response.dump()
        return response
    }
    
    open func apiRequest(route: EndPoint, replacingParams: [String : String] = [:], urlParams: [String : String?] = [:], params: [String : Any]?, completion: @escaping (_ response: ApiResponse) -> Void) {
        let convertedUrl = ApiRouter.base(route.url, replacingParams: replacingParams, urlParams: urlParams)
        
        request(convertedUrl, method: route.method, parameters: params, headers: nil).response { (response) in
            guard let httpUrlResponse = response.response else {
                completion(self.falseResponse(url: convertedUrl))
                return
            }
            
            let statusCode = httpUrlResponse.statusCode
            let result = route.successCodes.contains(statusCode)
            let apiResponse = ApiResponse(result: result,
                                          code: statusCode,
                                          error: result ? nil : statusCode.errorCodeDescription(),
                                          url: convertedUrl,
                                          json: self.getDictionary(from: response.data))
            
            apiResponse.dump()
            completion(apiResponse)
        }
    }
    
    open func loadImage(from url: URL?, completion: @escaping (_ image: UIImage?) -> Void) {
        var image: UIImage? = nil
        
        guard let url = url else {
            completion(image)
            return
        }
        
        Alamofire.request(url).responseImage { (response) in
            if let img = response.result.value {
                image = img
            }
            
            completion(image)
        }
    }
    
    private func getDictionary(from data: Data?) -> JSON? {
        guard let _ = data else {
            return nil
        }
        
        return JSON(data: data!)
    }
    
}
