//
//  AbstractViewController.swift
//  Shikimori
//
//  Created by Temirlan on 02.04.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class AbstractViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController!.popViewController(animated: true)
    }

}
