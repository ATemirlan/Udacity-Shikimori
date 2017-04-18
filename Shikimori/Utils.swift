//
//  Utils.swift
//  Shikimori
//
//  Created by Temirlan on 25.03.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    func popViewControllerAnimated(navController: UINavigationController, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        navController.popViewController(animated: true)
        CATransaction.commit()
    }
    
}

extension Date {

    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self as Date)
    }
    
}

extension String {
    
    func htmlAttributedString() -> NSAttributedString? {
        
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil
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
        
        for c in self.characters.map({ String($0) }) {
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
