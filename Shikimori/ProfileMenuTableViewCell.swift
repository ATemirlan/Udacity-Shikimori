//
//  ProfileMenuTableViewCell.swift
//  Shikimori
//
//  Created by Temirlan on 16.04.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class ProfileMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileView.layer.cornerRadius = profileView.frame.size.height / 2
        profileView.layer.borderWidth = 2.0
        profileView.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
