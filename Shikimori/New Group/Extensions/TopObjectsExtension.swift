//
//  TopObjectsExtension.swift
//  Shikimori
//
//  Created by Темирлан Алпысбаев on 12/28/17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import Foundation

extension UIViewController {
    
    static var segueID:String {
        return className
    }
    
    func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    func setEmptyBackButton(){
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        tabBarController?.navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
    }
    
}

extension UITableViewCell {
    
    static var cellID: String {
        return className
    }
    
    static var nibName: String {
        return className
    }
    
}

extension NSObject {
    
    var className: String {
        return type(of: self).className
    }
    
    static var className: String {
        return String(describing: self)
    }
}
