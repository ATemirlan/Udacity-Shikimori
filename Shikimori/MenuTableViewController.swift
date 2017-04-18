//
//  MenuTableViewController.swift
//  Shikimori
//
//  Created by Temirlan on 16.04.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.SystemColor.navBarColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupProfileCell()
    }
    
    func setupProfileCell() {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProfileMenuTableViewCell
        cell.nicknameLabel.text = User.current.nickname ?? "Профиль"
        
        if let _ = User.current.avatarUrl {
            cell.profileView.setImageWith(URL(string: User.current.avatarUrl!)!)
        } else {
            cell.profileView.image = UIImage(named: "temp_profile")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 0) {
            if let _ = User.current.token, let _ = User.current.id {
                RequestEngine.shared.getProfile(by: User.current.id!, completion: { (profile, error) in
                    if let _ = profile {
                        self.performSegue(withIdentifier: "ProfileSegue", sender: profile)
                    }
                })
            } else {
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                present(vc, animated: true, completion: {})
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileSegue" {
            let navvc = segue.destination as! UINavigationController
            
            for vc in navvc.viewControllers {
                if vc is ProfileViewController {
                    if let prof = sender as? Profile {
                        (vc as! ProfileViewController).profile = prof
                    }
                }
            }
        }
    }
    
}
