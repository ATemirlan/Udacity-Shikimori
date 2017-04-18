//
//  ProfilHeaderTableViewCell.swift
//  Shikimori
//
//  Created by Temirlan on 18.04.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class ProfilHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarView.layer.cornerRadius = avatarView.frame.size.height / 2
        avatarView.layer.borderWidth = 1.0
        avatarView.layer.borderColor = UIColor.lightGray.cgColor
    }

}
