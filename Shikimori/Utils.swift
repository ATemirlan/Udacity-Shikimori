//
//  Utils.swift
//  Shikimori
//
//  Created by Temirlan on 25.03.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    func pureString(str: String) -> String {

        return str
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
        default:
            return ""
        }
    }
    
    var animeStatus: String {
        switch self {
        case "ongoing":
            return "онгоинг"
        case "released":
            return "вышло"
        default:
            return ""
        }
    }
    
}
