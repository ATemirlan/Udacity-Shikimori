//
//  ProfileViewController.swift
//  Shikimori
//
//  Created by Temirlan on 16.04.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit
import MXParallaxHeader

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var notLabel: UILabel!
    
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
//        setup()
    }
    
    func setup() {
        if let _ = profile {
            setupHeader()
            getAnimes()
            tableView.isHidden = false
            loginButton.isHidden = true
            notLabel.isHidden = true
            logoutButton.image = UIImage(named: "logout")
        } else {
            logoutButton.image = UIImage()
            loginButton.isHidden = false
            notLabel.isHidden = false
            tableView.isHidden = true
        }
    }
    
    func getAnimes() {
        getAnimes(with: list.completed)
        getAnimes(with: list.dropped)
        getAnimes(with: list.on_hold)
        getAnimes(with: list.planned)
        getAnimes(with: list.watching)
    }

    func setupHeader() {
        avatarView.layer.cornerRadius = avatarView.frame.size.height / 2
        avatarView.layer.borderWidth = 1.0
        avatarView.layer.borderColor = UIColor.lightGray.cgColor
        
        tableView.parallaxHeader.view = headerView
        tableView.parallaxHeader.minimumHeight = 0
        tableView.parallaxHeader.height = 120
        tableView.parallaxHeader.mode = .center
        
//        avatarView.setImageWith(profile!.avatarUrl!, placeholderImage: UIImage(named: "temp_profile"))
        nicknameLabel.text = profile!.nickname ?? ""
    }
    
    func getAnimes(with type: String) {
        
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Выход.", message: "Вы уверены?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { (action) in
            User.current.deleteUser()
            self.profile = nil
            self.viewDidLoad()
        }))
            
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func presentLogin(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.delegate = self
        present(vc, animated: true, completion: {})
    }
    
    func showAll(but: UIButton) {
        var type: String? = nil
        
        switch but.tag {
        case 0:
            type = list.planned
        case 1:
            type = list.watching
        case 2:
            type = list.completed
        case 3:
            type = list.dropped
        case 4:
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

extension ProfileViewController: LoginDelegate {
    
    func loginCompleted(with profile: Profile?) {
        if let _ = profile {
            self.profile = profile
            viewDidLoad()
        }
    }
    
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "AnimeCell") as! AnimeSimilarTableViewCell
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
        if let list = chooseList(from: indexPath.section), list.count > 0 {
            return 166.0
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let _ = profile {
            let sectionView = UIView(frame: CGRect(x: 0.0, y: tableView.sectionHeaderHeight, width: view.frame.size.width, height: tableView.sectionHeaderHeight - 2.0))
            
            let titleLabel = UILabel(frame: CGRect(x: 8.0, y: tableView.sectionHeaderHeight, width: view.frame.size.width / 2 - 8.0, height: tableView.sectionHeaderHeight))
            titleLabel.font = UIFont.systemFont(ofSize: 14.0)
            titleLabel.text = sectionHeaders[section] + " " + properNumber(listType: section, profile: profile!)
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
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let list = chooseList(from: section) {
            return list.count > 0 ? 38.0 : CGFloat.leastNormalMagnitude
        } else {
            return CGFloat.leastNormalMagnitude
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
            
        }
    }
    
    func properNumber(listType: Int, profile: Profile) -> String {
        switch listType {
        case 0:
            if let _ = profile.planned {
                return "(\(profile.planned!))"
            }
            return ""
        case 1:
            if let _ = profile.watching {
                return "(\(profile.watching!))"
            }
            return ""
        case 2:
            if let _ = profile.completed {
                return "(\(profile.completed!))"
            }
            return ""
        case 3:
            if let _ = profile.dropped {
                return "(\(profile.dropped!))"
            }
            return ""
        case 4:
            if let _ = profile.on_hold {
                return "(\(profile.on_hold!))"
            }
            return ""
        default:
            return ""
        }
    }
    
    func setup(cell: SimilarAnimeCollectionViewCell, at indexPath: IndexPath) {
        if let animeList = chooseList(from: indexPath.section) {
            let anime = animeList[indexPath.row]
//            cell.imageView.setImageWith(anime.imageUrl!, placeholderImage: UIImage(named:"placeholder"))
        } else {
            cell.imageView.image = UIImage(named:"placeholder")
        }
    }
    
    func chooseList(from section: Int) -> [Anime]? {
        switch section {
        case 0:
            return plannedAnimes
        case 1:
            return watchingAnimes
        case 2:
            return completedAnimes
        case 3:
            return droppedAnimes
        case 4:
            return onholdAnimes
        default:
            return [Anime]()
        }
    }
    
}
