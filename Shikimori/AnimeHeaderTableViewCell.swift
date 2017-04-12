//
//  AnimeHeaderTableViewCell.swift
//  Shikimori
//
//  Created by Temirlan on 02.04.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class AnimeHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var originalTitleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var starView: AXRatingView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var statusLabe: UILabel!
    @IBOutlet weak var episodesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
