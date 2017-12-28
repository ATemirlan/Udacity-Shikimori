//
//  NewsViewController.swift
//  Shikimori
//
//  Created by Temirlan on 25.03.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var filterButton: UIBarButtonItem!

    var animes = [Anime]()
    var isSearchMode = false
    var reachesEnd = false
    var filter = Filter(page: 1)
    
    var type: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupFlowLayout()
    }
    
    func setupView() {
        if let _ = type {
            filterButton.image = nil
            collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            getAnimeList(with: filter)
        } else {
            collectionView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0)
            getAnimeList(with: filter)
        }
    }
    
    func goBack() {
        self.navigationController!.popViewController(animated: true)
    }
    
    func getAnimeList(with filter: Filter?) {
        RequestEngine.shared.getAnimes(with: filter) { (animes, error) in
            if let animes = animes {
                self.animes.append(contentsOf: animes)
                self.collectionView.reloadData()
                self.filter.page += 1
                
                if animes.count < self.filter.limit {
                    self.reachesEnd = true
                }
            } else {
                self.reachesEnd = true
                // TODO: Create Alert class to show messages and errors
//                print(error)
            }
        }
    }
    
    @IBAction func filter(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: FilterViewController.segueID, sender: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 50 {
            collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        
        if scrollView.contentOffset.y > 50 {
            collectionView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0)
        }
    }
}

extension NewsViewController: FiltersDelegate {
    
    func filterChanged(filter: Filter) {
        if filter.hasChanges() {
            self.filter = filter
            animes = [Anime]()
            collectionView.reloadData()
            getAnimeList(with: filter)
        }
    }
    
}

extension NewsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AnimeCollectionViewCell
        cell.setup(with: animes[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if animes.count > 0 {
            let lastElement = animes.count - 1
            
            if indexPath.row == lastElement {
                if !isSearchMode, !reachesEnd {
                    getAnimeList(with: filter)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if animes.count > 0 {
//            let anime = animes[indexPath.row]
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "searchBarView", for: indexPath)
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var sz = CGSize(width: view.frame.size.width, height: 50.0)
        
        if let _ = type {
            sz = CGSize(width: view.frame.size.width, height: CGFloat.leastNormalMagnitude)
        }

        return sz
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AnimeDetailsViewController.segueID {
            let vc = segue.destination as! AnimeDetailsViewController
            vc.anime = sender as? Anime
        } else if segue.identifier == FilterViewController.segueID {
            let vc = segue.destination as! FilterViewController
            vc.delegate = self
            vc.filter = filter.hasChanges() ? filter : Filter(page: 1)
        }
    }
    
    func setupFlowLayout() {
        let space: CGFloat = 8.0
        let dimensionW = (collectionView.frame.size.width - space) / 2.0
        let dimensionH = (collectionView.frame.size.height - 2 * space) / 2.25
        
        flowLayout.minimumInteritemSpacing = space / 2.0
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimensionW, height: dimensionH)
    }
    
}

extension NewsViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearchMode = true
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            animes = [Anime]()
            isSearchMode = false
            filter.page = 1
            // TODO: Clear filter
            getAnimeList(with: filter)
            searchBar.showsCancelButton = false
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isCyrillic {
           
        } else {
            Utils().showError(text: "Поиск производится по английскому названию", at: self)
        }
    }
    
}
