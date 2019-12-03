//
//  SearchTableViewController.swift
//  Frontier
//
//  Created by Lee Bryant on 11/25/19.
//  Copyright © 2019 Lee Bryant. All rights reserved.
//

import UIKit

struct HorseData {
    var id: Int
    var Name: String
    var Image: UIImage?
    var Band: Int
    var Location: String
    var Darted: Bool
    var DartDate: String?
}

var selectedIndex = 0

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var data = [HorseData]()
    var filteredData = [HorseData]()
    
    
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Search"
        
        // Init Data
        data.append(HorseData(id: 0, Name: "Joe", Image: UIImage(named: "joe"), Band: 0, Location: "Virginia", Darted: true, DartDate: "11.30.2019"))
        data.append(HorseData(id: 1, Name: "Alex", Image: UIImage(named: "alex"), Band: 0, Location: "Virginia", Darted: true, DartDate: "12.01.2019"))
        data.append(HorseData(id: 2, Name: "Alexis", Image: UIImage(named: "alexis"), Band: 1, Location: "Tahoe", Darted: false, DartDate: ""))
        
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return filteredData.count
        }
        
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if isSearching {
            cell.textLabel?.text = filteredData[indexPath.row].Name
            cell.detailTextLabel?.text = filteredData[indexPath.row].Location
            // cell.imageView?.image = filteredData[indexPath.row].Image
        } else {
            cell.textLabel?.text = data[indexPath.row].Name
            cell.detailTextLabel?.text = data[indexPath.row].Location
            // cell.imageView?.image = data[indexPath.row].Image
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = data[indexPath.row].id
        performSegue(withIdentifier: "horseView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! HorseViewController
        vc.data = data
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            filteredData = data.filter({ horse -> Bool in
                guard let text = searchBar.text else { return false }
                return horse.Name.contains(text) || horse.Location.contains(text)
            })
            tableView.reloadData()
        }
    }

}
