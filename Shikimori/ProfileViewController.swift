//
//  ProfileViewController.swift
//  Shikimori
//
//  Created by Temirlan on 16.04.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class ProfileViewController: CustomNavViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let list = Constants.MyList.self
    var profile: Profile?
    
    let sectionHeaders = ["Запланировано", "Смотрю", "Просмотрено", "Отложено", "Брошено"]
    var completedAnimes = [Anime]()
    var droppedAnimes = [Anime]()
    var onholdAnimes = [Anime]()
    var plannedAnimes = [Anime]()
    var watchingAnimes = [Anime]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "AnimeHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "AnimeHeader")
        
        getAnimes(with: list.completed)
        getAnimes(with: list.dropped)
        getAnimes(with: list.on_hold)
        getAnimes(with: list.planned)
        getAnimes(with: list.watching)
    }

    func getAnimes(with type: String) {
        RequestEngine.shared.getMyListAnimes(with: type) { (animes, error) in
            if let _ = error {
                
            } else {
                if let _ = animes, animes!.count > 0 {
                    switch type {
                    case self.list.completed:
                        self.completedAnimes.append(contentsOf: animes!)
                    case self.list.planned:
                        self.plannedAnimes.append(contentsOf: animes!)
                    case self.list.on_hold:
                        self.onholdAnimes.append(contentsOf: animes!)
                    case self.list.watching:
                        self.watchingAnimes.append(contentsOf: animes!)
                    case self.list.dropped:
                        self.droppedAnimes.append(contentsOf: animes!)
                    default:
                        return
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        Utils().popViewControllerAnimated(navController: navigationController!) { 
            User.current.deleteUser()
        }
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeader") as! ProfilHeaderTableViewCell
            
            if let _ = profile {
                cell.avatarView.setImageWith(profile!.avatarUrl!)
                cell.nickname.text = profile!.nickname
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnimeCell") as! AnimeSimilarTableViewCell

            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120.0
        case 1...5:
            if let list = chooseList(from: indexPath.section) {
                return list.count > 0 ? 166.0 : CGFloat.leastNormalMagnitude
            } else {
                return CGFloat.leastNormalMagnitude
            }
        default:
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? nil : sectionHeaders[section - 1]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        } else {
            if let list = chooseList(from: section) {
                return list.count > 0 ? 38.0 : CGFloat.leastNormalMagnitude
            } else {
                return CGFloat.leastNormalMagnitude
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let list = chooseList(from: collectionView.tag) {
            return list.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SimilarAnimeCollectionViewCell

        setup(cell: cell, at: IndexPath(row: indexPath.row, section: collectionView.tag))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let anime = completedAnimes[indexPath.row]
        
        RequestEngine.shared.getAnime(by: anime.id!, withProgress: true, completion: { (anim, error) in
            if let _ = anim {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AnimeDetailsViewController") as! AnimeDetailsViewController
                vc.anime = anim
                self.navigationController?.show(vc, sender: nil)
            }
        })
        
    }
    
    func setup(cell: SimilarAnimeCollectionViewCell, at indexPath: IndexPath) {
        if let animeList = chooseList(from: indexPath.section) {
            let anime = animeList[indexPath.row]
            cell.imageView.setImageWith(anime.imageUrl!, placeholderImage: UIImage(named:"placeholder"))
        }
    }
    
    func chooseList(from section: Int) -> [Anime]? {
        switch section {
        case 1:
            return plannedAnimes
        case 2:
            return watchingAnimes
        case 3:
            return completedAnimes
        case 4:
            return onholdAnimes
        case 5:
            return droppedAnimes
        default:
            return nil
        }
    }
    
}

