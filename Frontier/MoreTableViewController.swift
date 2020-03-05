//
//  SettingsTableViewController.swift
//  Frontier
//
//  Created by Jacob Spreitzer on 3/4/20.
//  Copyright © 2020 Lee Bryant. All rights reserved.
//

import UIKit

var MoreItems = ["Generate Report", "Account Settings", "Support Ticket", "About Us"]
var MoreIndex = 0

class MoreTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "More"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MoreItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreCell", for: indexPath)

        cell.textLabel?.text = MoreItems[indexPath.row]

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MoreIndex = indexPath.row
        
        switch (MoreIndex){
            case 0: performSegue(withIdentifier: "GenerateReport", sender: self)
                    break
            case 1: performSegue(withIdentifier: "Account", sender: self)
                    break
            case 2: performSegue(withIdentifier: "SupportTicket", sender: self)
                    break
            case 3: performSegue(withIdentifier: "About", sender: self)
                    break
            default:break
        }
    }

}
