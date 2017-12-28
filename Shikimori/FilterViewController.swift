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
    var sectionCounts: [Int]!
    var currRate: Int?
    
    var filterParamIndexes: [String : IndexPath?] = [
        "type" : nil,
        "status" : nil,
        "order" : nil
    ]
    
    var filter: Filter!
    
    var delegate: FiltersDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionCounts = [states.count, types.count, orders.count, 1, genres.count]
        fetchData()
    }
    
    func fetchData() {
        RequestEngine.shared.getGenres(isAnime: true) { (genres) in
            if let _ = genres {
                self.genres = genres!
                self.sectionCounts[4] = genres!.count
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func saveFilter(_ sender: UIBarButtonItem) {
        filter.type = getValue(from: "type")
        filter.status = getValue(from: "status")
        filter.order = getValue(from: "order")
        filter.score = currRate
        
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
        return sectionCounts[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rate_cell") as! RateFilterTableViewCell
            cell.delegate = self
            
            if let score = filter.score, let b = (cell.rates.filter { $0.tag == score }).first {
                cell.setSelected(but: b)
            }
            
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
                cell?.accessoryType = .none
                
                for g in filter.genres {
                    if g.id == genre.id { cell?.accessoryType = .checkmark }
                }
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
            var shouldAppend = true
            
            for g in filter.genres {
                if g.id == genre.id {
                    filter.genres.remove(at: filter.genres.index(of: g)!)
                    shouldAppend = false
                }
            }
            
            if shouldAppend { filter.genres.append(genre) }
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
