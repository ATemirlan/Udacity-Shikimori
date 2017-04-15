//
//  RateFilterTableViewCell.swift
//  Shikimori
//
//  Created by Temirlan on 15.04.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

protocol RateDelegate {
    func rateChoosed(rate: Int)
}
class RateFilterTableViewCell: UITableViewCell {

    @IBOutlet var rates: [RatingButton]!
    var currentRate: Int = 0
    var delegate: RateDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func rateChanged(_ sender: UIButton) {
        setSelected(but: sender)
        unselectAll(except: sender.tag)
        delegate?.rateChoosed(rate: currentRate)
    }
    
    func setSelected(but: UIButton) {
        if currentRate == but.tag {
            currentRate = 0
            but.backgroundColor = .white
            but.setTitleColor(Constants.SystemColor.blue, for: .normal)
        } else {
            but.backgroundColor = Constants.SystemColor.blue
            but.setTitleColor(.white, for: .normal)
            currentRate = but.tag
        }
    }
    
    func unselectAll(except: Int) {
        for b in rates {
            if b.tag != except {
                b.backgroundColor = .white
                b.setTitleColor(Constants.SystemColor.blue, for: .normal)
            }
        }
    }
}
