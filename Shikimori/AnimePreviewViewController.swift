//
//  AnimePreviewViewController.swift
//  Shikimori
//
//  Created by Temirlan on 01.04.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class AnimePreviewViewController: UIViewController, UIGestureRecognizerDelegate {

    var anime: Anime?
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var ratingView: AXRatingView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(close(_:)))
        view.addGestureRecognizer(tap)
        tap.delegate = self
        
        if let _ = anime {
            RequestEngine.shared.getAnime(by: anime!.id!, withProgress: false, completion: { (anim, error) in
                if let _ = anim {
                    self.anime = anim
                    self.titleLabel.text = self.anime?.russianName ?? self.anime?.name!
                    self.imageView.setImageWith(self.anime!.imageUrl!, placeholderImage: UIImage(named: "placeholder"))
                    self.ratingView.value = self.anime!.score! / 2.0
                    self.scoreLabel.text = "\(self.anime!.score!)"
                    self.genresLabel.text = self.anime!.genres!
                    self.typeLabel.text = self.anime!.kind?.animeType
                    self.descriptionLabel.text = self.anime?.descript ?? "NO DESCRIPTION"
                }
            })
        }
    }

    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !touch.view!.isDescendant(of: container)
    }
    
}
