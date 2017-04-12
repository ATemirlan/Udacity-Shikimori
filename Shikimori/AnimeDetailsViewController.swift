//
//  AnimeDetailsViewController.swift
//  Shikimori
//
//  Created by Temirlan on 01.04.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class AnimeDetailsViewController: AbstractViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var anime: Anime?
    var similarAnimes: [Anime]?
    var sectionTitles = ["Описание", "Похожее аниме"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        anime?.getAll()
        setupTableView()
        getSimilarSection()
        title = anime?.russianName ?? anime?.name
    }
    
    func getSimilarSection() {
        RequestEngine.shared.getSimilarAnimes(from: anime!.id!) { (similars, error) in
            if let _ = error {
                
            } else {
                self.similarAnimes = similars
                self.tableView.reloadData()
            }
        }
    }
}

extension AnimeDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnimeHeader") as! AnimeHeaderTableViewCell
            
            if let anime = anime {
                cell.avatarImageView.setImageWith(anime.imageUrl!, placeholderImage: UIImage(named: "placeholder"))
                cell.originalTitleLabel.text = anime.name
                
                if let _ = anime.kind {
                    var typeGenre = anime.kind!.animeType
                    
                    if let _ = anime.genres {
                        typeGenre += " | " + anime.genres!
                    }
                    
                    cell.typeLabel.text = typeGenre
                } else {
                    cell.typeLabel.text = "..."
                }
                
                if let _ = anime.episodes_aired {
                    cell.episodesLabel.text = (anime.episodes == anime.episodes_aired || anime.episodes_aired == 0) ? "\(anime.episodes!)" : "\(anime.episodes_aired!)/\(anime.episodes!)"
                }
                
                if let _ = anime.status {
                    var status = anime.status!.animeStatus
                    
                    if let _ = anime.released_on {
                        status += " в " + anime.released_on!.year
                    }
                    cell.statusLabe.text = status
                }
                
                if let _ = anime.score {
                    cell.scoreLabel.text = String(describing: anime.score!)
                    cell.starView.value = anime.score! / 2.0
                }
            }
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell") as! DescriptionTableViewCell

            cell.descriptionLabel.text = anime?.descript ?? "Нет описания"
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnimeSimilar") as! AnimeSimilarTableViewCell
            
            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return (similarAnimes != nil && similarAnimes!.count > 0) ? 166.0 : 0.0
        }
        
        return indexPath.section == 2 ? 166.0 : tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? CGFloat.leastNormalMagnitude : 32.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else {
            if section == 2 {
                if let _ = similarAnimes, similarAnimes!.count > 0 {
                    return sectionTitles[section - 1]
                } else {
                    return nil
                }
            } else {
                return sectionTitles[section - 1]
            }
        }
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: "AnimeHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "AnimeHeader")
    }
}

extension AnimeDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarAnimes?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SimilarAnimeCollectionViewCell
        
        if let similars = similarAnimes, similars.count > 0 {
            let similar = similars[indexPath.row]
            cell.imageView.setImageWith(similar.imageUrl!, placeholderImage: UIImage(named:"placeholder"))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let anime = similarAnimes?[indexPath.row] {
            RequestEngine.shared.getAnime(by: anime.id!, withProgress: true, completion: { (anim, error) in
                if let _ = anim {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AnimeDetailsViewController") as! AnimeDetailsViewController
                    vc.anime = anim
                    self.navigationController?.show(vc, sender: nil)
                }
            })
        }
    }

}
