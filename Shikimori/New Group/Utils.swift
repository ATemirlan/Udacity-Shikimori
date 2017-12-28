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
