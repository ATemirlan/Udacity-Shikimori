//
//  StringExtension.swift
//  Shikimori
//
//  Created by Темирлан Алпысбаев on 12/28/17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import Foundation

extension String {
    
    func htmlAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            return nil
        }
        
        guard let html = try? NSMutableAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil) else {
            return nil
        }
        
        let str = NSAttributedString(string: html.string, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14.0)])
        
        return str
    }
    
    var isCyrillic: Bool {
        let upper = "АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЮЯ"
        let lower = "абвгдежзийклмнопрстуфхцчшщьюя"
        
        for c in self.map({ String($0) }) {
            if !upper.contains(c) && !lower.contains(c) {
                return false
            }
        }
        
        return true
    }
    
    var animeType: String {
        switch self {
        case "tv":
            return "TV Сериал"
        case "movie":
            return "Фильм"
        case "ova":
            return "OVA"
        case "ona":
            return "ONA"
        case "special":
            return "Спешл"
        case "music":
            return "Клип"
        default:
            return ""
        }
    }
    
    var orderBy: String {
        switch self {
        case "ranked":
            return "Оценке"
        case "type":
            return "Типу"
        case "popularity":
            return "Популярности"
        case "name":
            return "Названию"
        case "status":
            return "Статусу"
        default:
            return ""
        }
    }
    
    var animeStatus: String {
        switch self {
        case "anons":
            return "Анонсировано"
        case "ongoing":
            return "Онгоинг"
        case "released":
            return "Вышло"
        default:
            return ""
        }
    }
    
}
