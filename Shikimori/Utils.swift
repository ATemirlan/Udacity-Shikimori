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
    
    func showError(text: String, at vc: UIViewController) {
        let controller = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        vc.present(controller, animated: true, completion: nil)
    }
    
}

extension Date {

    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self as Date)
    }
    
}

extension Int {
    
    func errorCodeDescription() -> String {
        if (300...399).contains(self) {
            return "Redirect error occured"
        } else if (400...499).contains(self) {
            switch self {
            case 400:
                return "Bad request"
            case 401:
                return "Unauthorized"
            case 403:
                return "Forbidden"
            case 404:
                return "Not found"
            case 405:
                return "Mthod not allowed"
            case 406:
                return "Not acceptable"
            default:
                return "Client error occured"
            }
        } else if (500...599).contains(self) {
            switch self {
            case 500:
                return "Internal server error"
            case 502:
                return "Bad gateway"
            case 503:
                return "Service unavailable"
            case 504:
                return "Gateway time-out"
            default:
                return "Server error"
            }
        }
        
        return "Unknown error occured"
    }
    
}

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
