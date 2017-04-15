//
//  AnimeCollectionViewCell.swift
//  Shikimori
//
//  Created by Temirlan on 25.03.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class AnimeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        titleContainer.backgroundColor = Constants.SystemColor.navBarColor.withAlphaComponent(0.8)
    }
    
}
