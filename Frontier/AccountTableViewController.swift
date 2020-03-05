//
//  AccountTableViewController.swift
//  Frontier
//
//  Created by Jacob Spreitzer on 3/4/20.
//  Copyright © 2020 Lee Bryant. All rights reserved.
//

import UIKit

var AccountItems = ["Change Email", "Change Password", "Logout"]
var AccountIndex = 0

class AccountTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Account"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AccountItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath)

        cell.textLabel?.text = AccountItems[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AccountIndex = indexPath.row
        /*      Still need to decide on what these options are gonna be */
        switch (AccountIndex){
            case 1: createAlert(title: "Password Reset", message: "An email has been sent to the address on file with a link to reset your password.")
                    break
            case 2: // Confirmation dialog taken from "http://swiftdeveloperblog.com/uialertcontroller-confirmation-dialog-swift/"
                    // Declare Alert message
                    let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to log out?", preferredStyle: .alert)
                    
                    // Create OK button with action handler
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        self.performSegue(withIdentifier: "Logout", sender: self)
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
                    
                    break
            default:break
            
        }
         
    }
    
    func createAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
