//
//  User.swift
//  Shikimori
//
//  Created by Temirlan on 16.04.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static let current = User()
    private override init() {}
    private let standard = UserDefaults.standard
    
    func deleteUser() {
        id = nil
        avatarUrl = nil
        nickname = nil
        token = nil
    }
    
    var id: String? {
        set(newId) {
            setStandard(string: newId, at: "userId")
        }
        get {
            return getStandardString(from: "userId")
        }
    }
    
    var avatarUrl: String? {
        set(newAvatarUrl) {
            setStandard(string: newAvatarUrl, at: "avatar")
        }
        get {
            return getStandardString(from: "avatar")
        }
    }
    
    var nickname: String? {
        set(newNickname) {
            setStandard(string: newNickname, at: "nickname")
        }
        get {
            return getStandardString(from: "nickname")
        }
    }
    
    var token: String? {
        set(newToken) {
            setStandard(string: newToken, at: "token")
        }
        get {
            return getStandardString(from: "token")
        }
    }
    
    func setStandard(string: String?, at key: String) {
        if let _ = string {
            UserDefaults.standard.set(string, forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
    
    func getStandardString(from key: String) -> String? {
        if let string = UserDefaults.standard.object(forKey: key) as? String {
            return string
        }
        
        return nil
    }
}
