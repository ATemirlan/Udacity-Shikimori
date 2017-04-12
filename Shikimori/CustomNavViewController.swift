//
//  CustomNavViewController.swift
//  Shikimori
//
//  Created by Temirlan on 01.04.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class CustomNavViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

}
