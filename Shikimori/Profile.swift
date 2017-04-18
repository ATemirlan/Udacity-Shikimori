//
//  Profile.swift
//  Shikimori
//
//  Created by Temirlan on 16.04.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class Profile: NSObject {

    var id: Int?
    var avatarUrl: URL?
    var sex: String?
    var name: String?
    var nickname: String?
    var birth_on: Date?
    
    var planned: Int?
    var watching: Int?
    var completed: Int?
    var on_hold: Int?
    var dropped: Int?
    
    init?(with info: [String : Any]) {
        
        if let id = info["id"] as? Int {
            User.current.id = "\(id)"
            self.id = id
        }

        if let name = info["name"] as? String {
            self.name = name
        }
        
        if let nickname = info["nickname"] as? String {
            User.current.nickname = nickname
            self.nickname = nickname
        }
        
        if let birth_on = info["birth_on"] as? Date {
            self.birth_on = birth_on
        }
        
        if let sex = info["sex"] as? String {
            self.sex = sex
        }
        
        if let imageArray = info["image"] as? [String : String] {
            if let highestResolution = imageArray["x160"] {
                avatarUrl = URL(string: highestResolution)
            } else if let midResolution = imageArray["x148"] {
                avatarUrl = URL(string: midResolution)
            } else if let lowResolution = imageArray["x80"] {
                avatarUrl = URL(string: lowResolution)
            }
        } else {
            if let avatar = info["avatar"] as? String {
                avatarUrl = URL(string: avatar)
            }
        }
        
        if let _ = avatarUrl {
            User.current.avatarUrl = "\(avatarUrl!)"
        }
        
        if let stats = info["stats"] as? [String : Any] {
            if let statuses = stats["statuses"] as? [String : Any] {
                if let anime = statuses["anime"] as? [[String : Any]] {
                    for obj in anime {
                        if let type = obj["grouped_id"] as? String {
                            if type.contains(Constants.MyList.watching), let num = obj["size"] as? Int {
                                self.watching = num
                            }
                            
                            switch type {
                            case Constants.MyList.planned:
                                if let num = obj["size"] as? Int {
                                    self.planned = num
                                }
                            case Constants.MyList.completed:
                                if let num = obj["size"] as? Int {
                                    self.completed = num
                                }
                            case Constants.MyList.dropped:
                                if let num = obj["size"] as? Int {
                                    self.dropped = num
                                }
                            case Constants.MyList.on_hold:
                                if let num = obj["size"] as? Int {
                                    self.on_hold = num
                                }
                            default:
                                continue
                            }
                        }
                    }
                }
            }
        }
        
        super.init()
    }
    
}
