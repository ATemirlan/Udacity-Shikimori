//
//  AnimeScreenshotsTableViewCell.swift
//  Shikimori
//
//  Created by Temirlan on 02.04.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class AnimeSimilarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    override func draw(_ rect: CGRect) {
        setupFlowLayout()
    }
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.setContentOffset(collectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        collectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { collectionView.contentOffset.x = newValue }
        get { return collectionView.contentOffset.x }
    }
    
    func setupFlowLayout() {
        let space: CGFloat = 8.0
        let dimensionH = 144.0
        let dimensionW = 102.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimensionW, height: dimensionH)
    }
    
}
