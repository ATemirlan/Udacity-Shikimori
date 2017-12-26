//
//  FilterViewController.swift
//  Shikimori
//
//  Created by Temirlan on 15.04.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

protocol FiltersDelegate {
    func filterChanged(filter: Filter)
}

class FilterViewController: AbstractViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var sections = ["СТАТУС", "ТИП", "СОРТИРОВАТЬ ПО", "ОЦЕНКА", "ЖАНРЫ"]
    var states = ["anons", "ongoing", "released"]
    var types = ["tv", "movie", "ova", "ona", "special", "music"]
    var orders = ["ranked", "type", "popularity", "name", "status"]
    var genres = [Genre]()
    var currRate: Int?
    var selectedGenres = [Genre]()
    var filterParamIndexes: [String : IndexPath?] = [
        "type" : nil,
        "status" : nil,
        "order" : nil
    ]
    
    var filter: Filter = Filter(page: 1)
    
    var delegate: FiltersDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func fetchData() {
        RequestEngine.shared.getGenres(isAnime: true) { (genres) in
            if let _ = genres {
                self.genres = genres!
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func saveFilter(_ sender: UIBarButtonItem) {
        filter.genres = selectedGenres
        filter.type = getValue(from: "type")
        filter.status = getValue(from: "status")
        filter.order = getValue(from: "order")
        filter.score = currRate
        filter.genres = selectedGenres
        
        Utils().popViewControllerAnimated(navController: navigationController!, completion: { 
            self.delegate?.filterChanged(filter: self.filter)
        })
    }
    
    func getValue(from key: String) -> String? {
        guard let index = getFilterIndex(from: key) else {
            return nil
        }
        
        switch key {
        case "type":
            return types[index]
        case "status":
            return states[index]
        case "order":
            return orders[index]
        default:
            return nil
        }
    }
    
    func getFilterIndex(from key: String) -> Int? {
        if let index = filterParamIndexes[key], index != nil {
            return index?.row
        }

        return nil
    }
    
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return states.count
        } else if section == 1 {
            return types.count
        } else if section == 2 {
            return orders.count
        } else if section == 3 {
            return 1
        } else if section == 4 {
            return genres.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rate_cell") as! RateFilterTableViewCell
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            
            cell?.accessoryType = filterContains(index: indexPath) ? .checkmark : .none
            cell?.accessoryView?.tintColor = Constants.SystemColor.blue
            
            if indexPath.section == 0 {
                cell?.textLabel?.text = states[indexPath.row].animeStatus
            } else if indexPath.section == 1 {
                cell?.textLabel?.text = types[indexPath.row].animeType
            } else if indexPath.section == 2 {
                cell?.textLabel?.text = orders[indexPath.row].orderBy
            } else if indexPath.section == 4 {
                let genre = genres[indexPath.row]
                cell?.textLabel?.text = genre.russianName
                cell?.accessoryType = selectedGenres.contains(genre) ? .checkmark : .none
            }
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 {
            return 54.0
        }
        
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            filterParamIndexes["status"] = filterContains(index: indexPath) ? nil : indexPath
        } else if indexPath.section == 1 {
            filterParamIndexes["type"] = filterContains(index: indexPath) ? nil : indexPath
        } else if indexPath.section == 2 {
            filterParamIndexes["order"] = filterContains(index: indexPath) ? nil : indexPath
        } else if indexPath.section == 4 {
            let genre = genres[indexPath.row]
            
            if selectedGenres.contains(genre) {
                selectedGenres.remove(at: selectedGenres.index(of: genre)!)
            } else {
                selectedGenres.append(genre)
            }
        }
        
        tableView.reloadData()
    }
    
    func filterContains(index: IndexPath) -> Bool {
        return filterParamIndexes.values.contains(where: { (indexPath) -> Bool in
            return indexPath == index
        })
    }
}

extension FilterViewController: RateDelegate {
    
    func rateChoosed(rate: Int) {
        currRate = rate
    }
    
}
