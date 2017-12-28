//
//  DateExtension.swift
//  Shikimori
//
//  Created by Темирлан Алпысбаев on 12/28/17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import Foundation

extension Date {
    
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self as Date)
    }
    
}
