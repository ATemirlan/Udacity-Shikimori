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
    
    func setup(with anime: Anime) {
        titleLabel.text = anime.russianName ?? anime.name
        typeLabel.text = anime.kind?.animeType ?? ""
        yearLabel.text = anime.aired_on?.year ?? ""
        

        if let url = anime.imageUrl {
            RequestEngine.shared.loadImage(from: url) { (image) in
                if let _ = image {
                    self.imageView.image = image!
                } else {
                    self.imageView.image = UIImage(named: "placeholder")
                }
            }
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
    
}
