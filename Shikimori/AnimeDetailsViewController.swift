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
    @IBOutlet weak var starButtonItem: UIBarButtonItem!
    
    var anime: Anime?
    var similarAnimes: [Anime]?
    var sectionTitles = ["Описание", "Похожее аниме"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = anime?.russianName ?? anime?.name
        
        setupBar()
        setupTableView()
        getSimilarSection()
    }
    
    func getSimilarSection() {
        RequestEngine.shared.getSimilarAnimes(from: anime!.id!) { (similars, error) in
            if let _ = error {
                Utils().showError(text: error!, at: self)
            } else {
                self.similarAnimes = similars
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func starAction(_ sender: UIBarButtonItem) {
        let list = Constants.MyList.self
        
        let alert = UIAlertController(title: "В какой список добавить аниме?", message: "", preferredStyle: .actionSheet)
        
        let completedAction = UIAlertAction(title: "Просмотрено", style: .default) { (action) in
            self.performAction(on: list.completed, completion: { (isAdded) in
                self.showNotification(isAdded: isAdded, alert: alert)
            })
        }
        
        let watchingAction = UIAlertAction(title: "Смотрю", style: .default) { (action) in
            self.performAction(on: list.watching, completion: { (isAdded) in
                self.showNotification(isAdded: isAdded, alert: alert)
            })
        }
        
        let plannedAction = UIAlertAction(title: "Запланировано", style: .default) { (action) in
            self.performAction(on: list.planned, completion: { (isAdded) in
                self.showNotification(isAdded: isAdded, alert: alert)
            })
        }
        
        let onholdAction = UIAlertAction(title: "Отложено", style: .default) { (action) in
            self.performAction(on: list.on_hold, completion: { (isAdded) in
                self.showNotification(isAdded: isAdded, alert: alert)
            })
        }
        
        let droppedAction = UIAlertAction(title: "Брошено", style: .default) { (action) in
            self.performAction(on: list.dropped, completion: { (isAdded) in
                self.showNotification(isAdded: isAdded, alert: alert)
            })
        }
        
        
        let removeAction = UIAlertAction(title: "Удлаить из списка", style: .destructive) { (action) in
            RequestEngine.shared.removeFromList(userRateId: self.anime!.userRateId!, completion: { (success, error) in
                if success == true {
                    self.starButtonItem.image = UIImage(named: "star")
                }
            })
        }
        
        
        let cancel = UIAlertAction(title: "Отменить", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(completedAction)
        alert.addAction(watchingAction)
        alert.addAction(plannedAction)
        alert.addAction(onholdAction)
        alert.addAction(droppedAction)
        
        if let _ = anime?.userRateId {
            alert.addAction(removeAction)
        }
        
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func performAction(on list: String, completion: @escaping (_ isAdded: Bool) -> Void) {
        RequestEngine.shared.add(anime: anime!.id!, to: list) { (isAdded, error) in
            if let _ = error {
                completion(false)
            } else {
                completion(isAdded)
            }
        }
    }
    
    func showNotification(isAdded: Bool, alert: UIAlertController) {
        if isAdded {
            self.starButtonItem.image = UIImage(named: "star_filled")
        } else {
            Utils().showError(text: "", at: self)
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
            
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            
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
    
    func setupBar() {
        if User.current.id == nil {
            starButtonItem.image = UIImage()
        } else {
            if let _ = anime?.userRateId {
                self.starButtonItem.image = UIImage(named: "star_filled")
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
                } else if let _ = error {
                    Utils().showError(text: error!, at: self)
                }
            })
        }
    }

}
