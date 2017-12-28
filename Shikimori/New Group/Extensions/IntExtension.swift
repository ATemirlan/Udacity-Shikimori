//
//  IntExtension.swift
//  Shikimori
//
//  Created by Темирлан Алпысбаев on 12/28/17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import Foundation

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
