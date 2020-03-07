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
        
        switch(HorseDartData[indexPath.row].Action) {
            case "P":
                cell.textLabel?.text = "Primer"
            case "B":
                cell.textLabel?.text = "Booster"
            default:break
        }
        
        // Date Format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale   = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        guard let date = dateFormatter.date(from: HorseDartData[indexPath.row].Date) else {
            fatalError()
        }
        
        // Date date to custom string
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let newDate = dateFormatter.string(from: date)

        cell.detailTextLabel?.text = newDate
        
        return cell
    }
}
