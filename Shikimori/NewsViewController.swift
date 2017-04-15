//
//  NewsViewController.swift
//  Shikimori
//
//  Created by Temirlan on 25.03.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class NewsViewController: CustomNavViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    var animes = [Anime]()
    var previewAnime: Anime?
    var page = 1
    var isSearchMode = false
    var reachesEnd = false
    var filter: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0)
        getAnimeList(with: filter, at: page)
        setupLongGesture()
    }
    
    func getAnimeList(with filter: String?, at page: Int) {
        RequestEngine.shared.getAnimes(with: filter, at: page) { (animes, error) in
            if let _ = animes, animes!.count > 0 {
                self.animes.append(contentsOf: animes!)
                
                if page == 1 {
                    self.setupFlowLayout()
                }
                
                if animes!.count < 50 {
                    self.reachesEnd = true
                }
                
                self.page += 1
            }
            
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func filter(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "filterSegue", sender: nil)
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
    
    func filterUrlPostfix(url: String) {
        if url != "" {
            page = 1
            filter = url
            animes = [Anime]()
            getAnimeList(with: filter, at: page)
        }
    }
    
}

extension NewsViewController: UIViewControllerPreviewingDelegate, UIGestureRecognizerDelegate {
    
    func setupLongGesture() {
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AnimeDetailsViewController") as? AnimeDetailsViewController {
            if let _ = previewAnime {
                RequestEngine.shared.getAnime(by: previewAnime!.id!, withProgress: false, completion: { (anim, error) in
                    if let _ = anim {
                        vc.anime = anim!
                        self.show(vc, sender: self)
                    }
                })
            }
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView.indexPathForItem(at: self.view.convert(location, to: collectionView)) else {
            return nil
        }
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AnimePreviewViewController") as? AnimePreviewViewController else {
            return nil
        }
        
        let anime = animes[indexPath.row]
        vc.anime = anime
        previewAnime = anime
        
        return vc
    }
}

extension NewsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AnimeCollectionViewCell
        
        if animes.count > 0 {
            let anime = animes[indexPath.row]
            cell.titleLabel.text = anime.russianName ?? anime.name
            cell.typeLabel.text = anime.kind?.animeType ?? ""
            cell.yearLabel.text = anime.aired_on?.year ?? ""
            
            if let _ = anime.imageUrl {
                cell.imageView.setImageWith(anime.imageUrl!, placeholderImage: UIImage(named: "placeholder"))
            } else {
                cell.imageView.image = UIImage(named: "placeholder")
            }   
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if animes.count > 0 {
            let lastElement = animes.count - 1
            
            if indexPath.row == lastElement {
                if !isSearchMode, !reachesEnd {
                    getAnimeList(with: filter, at: page)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if animes.count > 0 {
            let anime = animes[indexPath.row]
            
            RequestEngine.shared.getAnime(by: anime.id!, withProgress: true, completion: { (anim, error) in
                if let _ = anim {
                    self.performSegue(withIdentifier: "animeDetails", sender: anim)
                }
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "searchBarView", for: indexPath)
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPreview" {
            let vc = segue.destination as! AnimePreviewViewController
            vc.anime = sender as? Anime
        } else if segue.identifier == "animeDetails" {
            let vc = segue.destination as! AnimeDetailsViewController
            vc.anime = sender as? Anime
        } else if segue.identifier == "filterSegue" {
            let vc = segue.destination as! FilterViewController
            vc.delegate = self
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
            page = 1
            getAnimeList(with: nil, at: page)
            searchBar.showsCancelButton = false
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isCyrillic {
            RequestEngine.shared.searchAnimes(by: searchBar.text!) { (animes, error) in
                if let _ = error {
                    print(error!)
                } else {
                    if let _ = animes {
                        self.animes = animes!
                        self.collectionView.reloadData()
                    }
                }
            }
        } else {
            print("Поиск производится по английскому названию")
        }
    }
    
}
