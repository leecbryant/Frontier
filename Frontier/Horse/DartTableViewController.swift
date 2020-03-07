//
//  DartTableViewController.swift
//  Frontier
//
//  Created by Lee Bryant on 3/6/20.
//  Copyright © 2020 Lee Bryant. All rights reserved.
//

import UIKit

class DartTableViewController: UITableViewController {
    var HorseDartData = [Treatment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Dart Log"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return HorseDartData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dartCell", for: indexPath)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        switch(HorseDartData[indexPath.row].Action) {
            case "P":
                cell.textLabel?.text = "Primer"
            case "B":
                cell.textLabel?.text = "Booster"
            default:break
        }
        
        cell.detailTextLabel?.text = HorseDartData[indexPath.row].Date
        
        return cell
    }
}
