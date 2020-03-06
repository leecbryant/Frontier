//
//  AccountTableViewController.swift
//  Frontier
//
//  Created by Jacob Spreitzer on 3/4/20.
//  Copyright © 2020 Lee Bryant. All rights reserved.
//

import UIKit

var AccountItems = ["Change Email", "Change Password"]
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
            case 0:
                print("EMAIL Reseet")
            case 1: createAlert(title: "Password Reset", message: "An email has been sent to the address on file with a link to reset your password.")
            default:break
            
        }
         
    }
    
    func createAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
