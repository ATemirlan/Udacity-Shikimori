//
//  RatingButton.swift
//  Shikimori
//
//  Created by Temirlan on 15.04.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class RatingButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 8.0
        layer.borderWidth = 1.0
        layer.borderColor = Constants.SystemColor.blue.cgColor
    }

}
