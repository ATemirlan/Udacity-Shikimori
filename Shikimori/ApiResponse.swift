//
//  ApiResponse.swift
//  Shikimori
//
//  Created by Темирлан Алпысбаев on 12/20/17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import SwiftyJSON

struct ApiResponse {
    
    var result: Bool
    var code: Int
    var error: String?
    var url: String?
    var json: JSON?
    
    func dump() {
        print("-------------------")
        print("URL: \(url ?? "NO URL")")
        print("Result: \(result)")
        print("Code: \(code)")
        print("Error: \(error ?? "NO ERROR")")
        
        if let _ = json {
//            print("JSON: \(json!)")
        }
        print("-------------------")
    }
    
}
