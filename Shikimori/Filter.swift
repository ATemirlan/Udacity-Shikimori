//
//  Filter.swift
//  Shikimori
//
//  Created by Темирлан Алпысбаев on 12/22/17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import Foundation

struct Filter {
    
    var page: Int
    
    var section: String?
    var status: String?
    var type: String?
    var order: String?
    var genres: [Genre]?
    var score: Int?
    
    init(page: Int) {
        self.page = page
    }
    
    func hasChanges() -> Bool {
        if (section != nil || status != nil || type != nil || order != nil ||
        (genres != nil && genres!.count > 0) ||
        (score != nil && score! > 0)) {
            return true
        }
        
        return false
    }
    
    func toDict() -> [String : String?] {
        return [
            "censored" : "true",
            "limit" : "5",
            "page" : String(page),
            "section" : section,
            "status" : status,
            "type" : type,
            "order" : order,
//            "genres" : genres,
            "score" : score != nil ? String(score!) : nil
        ]
    }
    
}
