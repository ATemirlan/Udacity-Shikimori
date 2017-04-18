//
//  AppDelegate.swift
//  Shikimori
//
//  Created by Temirlan on 25.03.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupNavBar()
        checkWhoAmI()
        
        return true
    }
    
    func checkWhoAmI() {
        RequestEngine.shared.whoami { (profile) in
            if let _ = profile {
                User.current.id = "\(profile!.id!)"
                User.current.nickname = profile!.nickname!
                User.current.avatarUrl = "\(profile!.avatarUrl!)"
            }
        }
    }
    
    func setupNavBar() {
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().barTintColor = Constants.SystemColor.navBarColor
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
    }
    
}

