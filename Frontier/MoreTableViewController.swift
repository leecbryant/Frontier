//
//  SettingsTableViewController.swift
//  Frontier
//
//  Created by Jacob Spreitzer on 3/4/20.
//  Copyright © 2020 Lee Bryant. All rights reserved.
//

import UIKit

var MoreItems = ["Account Settings", "Support Ticket", "About Us", "Logout"]
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
        
        if(cell.textLabel?.text == "Logout") {
            cell.textLabel?.textColor = .red
        }
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MoreIndex = indexPath.row
        
        switch (MoreIndex){
            case 0: performSegue(withIdentifier: "Account", sender: self)
                    break
            case 1: performSegue(withIdentifier: "SupportTicket", sender: self)
                    break
            case 2: performSegue(withIdentifier: "About", sender: self)
                    break
            case 3:
                // Declare Alert message
                let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to log out?", preferredStyle: .alert)
                
                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    self.dismiss(animated: true, completion: nil)
                })
                
                // Create Cancel button with action handlderc
                let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                    self.tableView.deselectRow(at: indexPath, animated: true)
                }
                
                //Add OK and Cancel button to dialog message
                dialogMessage.addAction(ok)
                dialogMessage.addAction(cancel)
                
                // Present dialog message to user
                self.present(dialogMessage, animated: true, completion: nil)
            default:break
        }
    }

}
