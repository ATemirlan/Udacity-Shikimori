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
    
    let list = Constants.MyList.self
    var storedOffsets = [Int: CGFloat]()
    var profile: Profile?
    
    let sectionHeaders = ["Запланировано", "Смотрю", "Просмотрено", "Брошено", "Отложено"]
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
        
        self.automaticallyAdjustsScrollViewInsets = false
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
    
    func showAll(but: UIButton) {
        var type: String? = nil
        
        switch but.tag {
        case 1:
            type = list.planned
        case 2:
            type = list.watching
        case 3:
            type = list.completed
        case 4:
            type = list.dropped
        case 5:
            type = list.on_hold
        default:
            type = nil
        }
        
        if let _ = type {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "MainCollectionViewController") as! NewsViewController
            vc.type = type!
            
            let nvc = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            nvc.setViewControllers([vc], animated: true)
            
            show(vc, sender: true)
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
            return tableView.dequeueReusableCell(withIdentifier: "AnimeCell") as! AnimeSimilarTableViewCell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let tableCell = cell as? AnimeSimilarTableViewCell {
            tableCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
            tableCell.collectionViewOffset = storedOffsets[indexPath.section] ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let tableCell = cell as? AnimeSimilarTableViewCell {
            storedOffsets[indexPath.section] = tableCell.collectionViewOffset
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120.0
        case 1...5:
            if let list = chooseList(from: indexPath.section), list.count > 0 {
                return 166.0
            } else {
                return CGFloat.leastNormalMagnitude
            }
        default:
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        } else {
            let sectionView = UIView(frame: CGRect(x: 0.0, y: tableView.sectionHeaderHeight, width: view.frame.size.width, height: tableView.sectionHeaderHeight - 2.0))
            
            let titleLabel = UILabel(frame: CGRect(x: 8.0, y: tableView.sectionHeaderHeight, width: view.frame.size.width / 2 - 8.0, height: tableView.sectionHeaderHeight))
            titleLabel.font = UIFont.systemFont(ofSize: 14.0)
            titleLabel.text = sectionHeaders[section - 1] + " " + properNumber(listType: section, profile: profile!)
            titleLabel.textColor = .black
            
            let but = UIButton(frame: CGRect(x: view.frame.size.width / 2, y: tableView.sectionHeaderHeight, width: view.frame.size.width / 2 - 8.0, height: tableView.sectionHeaderHeight))
            but.addTarget(self, action: #selector(showAll), for: .touchUpInside)
            but.setTitle("Просмотреть все ❭", for: .normal)
            but.setTitleColor(Constants.SystemColor.blue, for: .normal)
            but.titleLabel!.font = UIFont.systemFont(ofSize: 14.0)
            but.contentHorizontalAlignment = .right
            but.contentVerticalAlignment = .bottom
            but.tag = section
            
            sectionView.clipsToBounds = true
            sectionView.addSubview(titleLabel)
            sectionView.addSubview(but)
            
            return sectionView
        }
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
        
        if let list = chooseList(from: collectionView.tag) {
            let anime = list[indexPath.row]
            
            RequestEngine.shared.getAnime(by: anime.id!, withProgress: true, completion: { (anim, error) in
                if let _ = anim {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AnimeDetailsViewController") as! AnimeDetailsViewController
                    vc.anime = anim
                    self.navigationController?.show(vc, sender: nil)
                } else {
                    if let _ = error {
                        
                    }
                }
            })
        }
    }
    
    func properNumber(listType: Int, profile: Profile) -> String {
        switch listType {
        case 1:
            return "(\(profile.planned ?? 0))"
        case 2:
            return "(\(profile.watching ?? 0))"
        case 3:
            return "(\(profile.completed ?? 0))"
        case 4:
            return "(\(profile.dropped ?? 0))"
        case 5:
            return "(\(profile.on_hold ?? 0))"
        default:
            return "(0)"
        }
    }
    
    func setup(cell: SimilarAnimeCollectionViewCell, at indexPath: IndexPath) {
        if let animeList = chooseList(from: indexPath.section) {
            let anime = animeList[indexPath.row]
            cell.imageView.setImageWith(anime.imageUrl!, placeholderImage: UIImage(named:"placeholder"))
        } else {
            cell.imageView.image = UIImage(named:"placeholder")
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
            return droppedAnimes
        case 5:
            return onholdAnimes
        default:
            return [Anime]()
        }
    }
    
}
