//
//  SearchTableViewController.swift
//  Frontier
//
//  Created by Lee Bryant on 11/25/19.
//  Copyright © 2019 Lee Bryant. All rights reserved.
//

import UIKit

struct HorseData: Decodable {
    var id: Int
    var Name: String
    var Image: String
    var Band: Int
    var Color: String
    var Mane: String?
    var Face: String?
    var Whorl: String?
    var rfFeet: String?
    var rrFeet: String?
    var lfFeet: String?
    var lrFeet: String?
    var Location: String
    var DartStatus: String
    var DartDate: String
}

struct Features {
    var Color: [String]
    var Mane: [String]
    var Face: [String]
    var Whorl: [String]
    var rightFront: [String]
    var rightBack: [String]
    var leftFront: [String]
    var leftBack: [String]
}


var selectedIndex = 0

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var AdvancedButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var data = [HorseData]()
    var filteredData = [HorseData]()
    var advancedFeatures = Features(Color: [], Mane: [], Face: [], Whorl: [], rightFront: [], rightBack: [], leftFront: [], leftBack: [])
    var count = 0
    
    var isSearching = false
    
    // Loading Circle
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        super.viewDidLoad()
        navigationItem.title = "Search"
        
        // Init Data
        //        data.append(HorseData(id: 0, Name: "Joe", Image: UIImage(named: "joe"), Band: 0, Color: "Black", Location: "Virginia", DartStatus: "true", DartDate: "11.30.2019"))
        //        data.append(HorseData(id: 1, Name: "Alex", Image: UIImage(named: "alex"), Band: 0, Color: "Appaloosa", Location: "Virginia", DartStatus: "true", DartDate: "12.01.2019"))
        //        data.append(HorseData(id: 2, Name: "Alexis", Image: UIImage(named: "alexis"), Band: 1, Color: "Brown", Location: "Tahoe", DartStatus: "false", DartDate: ""))
        
        parseJSON(withCompletion: { horseData, error in
            if error != nil {
                print(error!)
            } else if let horseData = horseData {
                self.data = horseData
                self.filteredData = horseData
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        })
        print(data.count)
        //Always make filteredData a copy of data when there is no filter applied
        filteredData = data
        
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
        switch segue.identifier {
            case "horseView":
                let vc = segue.destination as! HorseViewController
                vc.data = filteredData
            break
            case "showAdvanced":
                let vc = segue.destination as! FeatureListScreen
                vc.selectedFeatures = advancedFeatures
                vc.delegate = self
            break
            case "historySegue": break
                //let vc = segue.destination as! FeatureSe
            default: break
            // Unreachable
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text?.trimmingCharacters(in: .whitespaces) == "" {
            //Always make filteredData a copy of data when there is no filter applied
            filteredData=data
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            

            filteredData = data.filter({ horse -> Bool in
                guard let text = searchBar.text else { return false }
                
                let textArr = text.trimmingCharacters(in: .whitespaces).lowercased().components(separatedBy: " ")
                //Variable to keep track of if a horse matches any features
                var retHorse = false
                
                //Loop through all inputted features and see if current horse fits any of them
                //If current horse matches a searched filter, retHorse will be set to true and then then add the current to the filtered array
                for myText in textArr{
                    retHorse =  horse.Name.lowercased().contains(myText.lowercased()) || horse.Location.lowercased().contains(myText.lowercased())
                }
                //Return false if horse match no features
                return retHorse
                
                
            })
            tableView.reloadData()
        }
    }
    
    @IBAction func advancedClick() {
        performSegue(withIdentifier: "showAdvanced", sender: self)
    }
    
    func parseJSON(withCompletion completion: @escaping ([HorseData]?, Error?) -> Void) {
        let jsonUrlString = "https://projectfrontier.dev/horseData.json"
            guard let url = URL(string: jsonUrlString) else { return }
            
        let task = URLSession.shared.dataTask(with: url) { (horseData, response, err) in
            guard let horseData = horseData else { return }
            do {
                let horses = try JSONDecoder().decode([HorseData].self, from: horseData)
                completion(horses, nil)
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
               completion(nil, err)
            }
        }
        
        task.resume()
    }

}

extension SearchTableViewController: PassDataToSearch {
    func advancedPassBack(userInput: Features) {
        advancedFeatures = userInput
        
        print(advancedFeatures.Color)
                
        count = advancedFeatures.Color.count + advancedFeatures.Mane.count +
            advancedFeatures.Face.count + advancedFeatures.Whorl.count +
            advancedFeatures.rightFront.count + advancedFeatures.rightBack.count +
            advancedFeatures.leftFront.count + advancedFeatures.leftBack.count
        
        if(count > 0) {
            AdvancedButton?.addBadge(text: String(count))
            isSearching = true
            filteredData = data.filter({ horse -> Bool in
                return advancedFeatures.Color.contains(horse.Color)
            })
            tableView.reloadData()
        } else {
            isSearching = false
            AdvancedButton?.removeBadge()
        }
    }
}
