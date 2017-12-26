//
//  Genre.swift
//  Shikimori
//
//  Created by Temirlan on 15.04.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import SwiftyJSON

class Genre: NSObject {
    
    var id: Int
    var kind: String
    var name: String?
    var russianName: String?
    
    private var wrongGenres = ["Хентай", "Яой", "Юри"]
    
    init?(with json: JSON) {
        self.id = json["id"].intValue
        self.kind = json["kind"].stringValue
        self.name = json["name"].stringValue
        self.russianName = json["russian"].stringValue
        
        if wrongGenres.contains(self.russianName!) {
            return nil
        }

        super.init()
    }
    
}
