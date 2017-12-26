//
//  ApplicationRouter.swift
//  Shikimori
//
//  Created by Темирлан Алпысбаев on 12/21/17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import Foundation

class ApplicationRouter {
    
    static func viewController(storyboardID: String, id: String) -> UIViewController {
        return storyboard(storyboardID).instantiateViewController(withIdentifier: id)
    }
    
    private static func storyboard(_ storyboardName: String) -> UIStoryboard {
        return UIStoryboard(name: storyboardName, bundle: nil)
    }
    
}
