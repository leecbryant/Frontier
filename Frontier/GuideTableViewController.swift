//
//  GuideTableViewController.swift
//  Frontier
//
//  Created by Lee Bryant on 11/25/19.
//  Copyright © 2019 Lee Bryant. All rights reserved.
//

import UIKit

var items = ["Color", "Mane", "Face", "Whorl", "Sock Types", "Terminology"]
var myIndex = 0

class GuideTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Guide"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = items[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "guideDesc", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is GuideViewController
        {
            let vc = segue.destination as? GuideViewController
            vc?.items = items
            vc?.selectedIndex = myIndex
        }
    }
}
