//
//  Genre.swift
//  Shikimori
//
//  Created by Temirlan on 15.04.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class Genre: NSObject {
    
    var id: Int?
    var kind: String?
    var name: String?
    var russianName: String?
    
    init?(with genreInfo: [String : Any]){
        if let kind = genreInfo["kind"] as? String, kind == "anime" {
            if let id = genreInfo["id"] as? Int {
                self.id = id
            }
            
            if let name = genreInfo["name"] as? String {
                self.name = name
            }
            
            if let russian = genreInfo["russian"] as? String {
                if russian == "Хентай" || russian == "Яой" || russian == "Юри" {
                    return nil
                }
                self.russianName = russian
            }
        } else {
            return nil
        }
        
        super.init()
    }
    
}
