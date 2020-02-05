//
//  HorseViewController.swift
//  Frontier
//
//  Created by Lee Bryant on 11/25/19.
//  Copyright © 2019 Lee Bryant. All rights reserved.
//

import UIKit

var Bands = ["Wild Riders", "South Riders", "Wild Riders", "South Riders", "Wild Riders", "South Riders", "Wild Riders", "South Riders", "Wild Riders", "South Riders", "Wild Riders", "South Riders", "Wild Riders", "South Riders", "Wild Riders", "South Riders", "Wild Riders", "South Riders"]
var filteredBands = [HorseData]()

class HorseViewController: UIViewController {
    
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var bandText: UILabel!
    @IBOutlet weak var dartedText: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var horseImage: UIImageView!
    
    @IBOutlet weak var bandMembers: UILabel!
    
    var data = [HorseData]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        filterBands()
        navigationItem.title = "Horse Information"
        
        nameText.text = data[selectedIndex].Name
        bandText.text = Bands[data[selectedIndex].Band]
        dartedText.text = data[selectedIndex].DartStatus
        horseImage.image = UIImage(named: data[selectedIndex].Image.lowercased())
        
        if filteredBands.count > 0 {
            bandMembers.isHidden = false
        } else {
            bandMembers.isHidden = true
        }
    }
    
    func filterBands() {
        filteredBands = data.filter({ horse -> Bool in
            return horse.Band == data[selectedIndex].Band && horse.Name != data[selectedIndex].Name
        })
    }
}

extension HorseViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredBands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bandCell", for: indexPath)
        cell.textLabel?.text = filteredBands[indexPath.row].Name
        cell.detailTextLabel?.text = filteredBands[indexPath.row].Location
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row Selected with id: \(filteredBands[indexPath.row].id)")
        selectedIndex = filteredBands[indexPath.row].id
        self.viewDidLoad()
        self.viewWillAppear(true)
        filterBands()
        tableView.reloadData()
    }
}
