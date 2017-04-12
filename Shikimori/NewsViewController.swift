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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0)
        getAnimeList(at: page)
        setupLongGesture()
    }
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func getAnimeList(at page: Int) {
        RequestEngine.shared.getAnimes(at: page) { (animes, error) in
            if let _ = animes, animes!.count > 0 {
                self.animes.append(contentsOf: animes!)
                self.collectionView.reloadData()
                
                if page == 1 {
                    self.setupFlowLayout()
                }
                
                self.page += 1
            }
        }
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

extension NewsViewController: UIViewControllerPreviewingDelegate, UIGestureRecognizerDelegate {
    
    func setupLongGesture() {
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        } else {
            let gesture : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
            gesture.minimumPressDuration = 0.6
//            collectionView.addGestureRecognizer(gesture)
        }
    }
    
    func handleLongPress(gesture : UILongPressGestureRecognizer) {
        let p = gesture.location(in: collectionView)
        let path = collectionView.indexPathForItem(at: p)
        
        if animes.count > 0 {
            if let _ = path {
                let anime = animes[path!.row]
                
                let vc = storyboard?.instantiateViewController(withIdentifier: "AnimePreviewViewController") as! AnimePreviewViewController
                vc.anime = anime
                
                let w = view.frame.size.width * 0.85
                let h = view.frame.size.height * 0.85
                let dimView = UIView(frame: CGRect(x: view.frame.size.width/2 - w/2, y: view.frame.size.height/2 - h/2, width: w, height: h))
                dimView.tag = 32
                
                vc.view.frame = CGRect(x: dimView.frame.origin.x, y: dimView.frame.origin.y, width: w, height: h)
                
                if gesture.state == .began {
                    dimView.addSubview(vc.view)
                    view.addSubview(dimView)
                } else if gesture.state == .ended {
                    for v in view.subviews {
                        if v.tag == 32 {
                            v.removeFromSuperview()
                        }
                    }
                }

            }
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
                if !isSearchMode {
                    getAnimeList(at: page)
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
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            animes = [Anime]()
            isSearchMode = false
            page = 1
            getAnimeList(at: page)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
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
    }
    
}
