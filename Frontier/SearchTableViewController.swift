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
    var Mane: String
    var Face: String
    var Whorl: String
    var rfFeet: String
    var rrFeet: String
    var lfFeet: String
    var lrFeet: String
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

class SearchTableViewController: UITableViewController, UISearchBarDelegate, PassDataToSearch {
    
    @IBOutlet weak var AdvancedButton: UIBarButtonItem!
    //@IBOutlet weak var searchBar: UISearchBar!
    
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
        navigationItem.title = "Horses"
        
        showSearchBar()
        
        parseJSON(withCompletion: { horseData, error in
            if error != nil {
                print(error!)
                self.createAlert(title: "Error", message: "Error loading horse data")
            } else if let horseData = horseData {
                self.data = horseData
                self.filteredData = horseData
                self.loadComplete()
                
            }
        })
        
        //Always make filteredData a copy of data when there is no filter applied
        filteredData = data
        
    }

    func loadComplete() {
       DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            UIApplication.shared.endIgnoringInteractionEvents()
            self.tableView.reloadData()
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
       }
    }
    
    //Generates search bar data for search screen
    func showSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        //true for hiding, false for keep showing while scrolling
        navigationItem.hidesSearchBarWhenScrolling = false
        //Prevents text from dissappearing when clicking off searchbar
        searchController.obscuresBackgroundDuringPresentation = false        
        searchController.searchBar.sizeToFit()
        searchController.searchBar.returnKeyType = UIReturnKeyType.search
        searchController.searchBar.placeholder = "Search here"
        searchController.searchBar.showsCancelButton = false
        
        navigationItem.searchController = searchController
    }
    
    // MARK: - Table view data source
    // Comment for GIT
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
            filteredData.sort(by: {$0.Name < $1.Name})
            cell.textLabel?.text = filteredData[indexPath.row].Name
            cell.detailTextLabel?.text = filteredData[indexPath.row].Location
            // cell.imageView?.image = filteredData[indexPath.row].Image
        } else {
            filteredData.sort(by: {$0.Name < $1.Name})
            cell.textLabel?.text = filteredData[indexPath.row].Name
            cell.detailTextLabel?.text = "County: " + data[indexPath.row].Location            // cell.imageView?.image = data[indexPath.row].Image
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = filteredData[indexPath.row].id
        performSegue(withIdentifier: "horseView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "horseView":
                let vc = segue.destination as! HorseViewController
                vc.data = data
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
            filteredData = data.filter({ horse -> Bool in
                return
                    (advancedFeatures.Color.count > 0 ? advancedFeatures.Color.contains(horse.Color) : true) &&
                    (advancedFeatures.Face.count > 0 ? advancedFeatures.Face.contains(horse.Face) : true) &&
                    (advancedFeatures.Mane.count > 0 ? advancedFeatures.Mane.contains(horse.Mane) : true) &&
                    (advancedFeatures.Whorl.count > 0 ? advancedFeatures.Whorl.contains(horse.Whorl) : true) &&
                    (advancedFeatures.rightFront.count > 0 ? advancedFeatures.rightFront.contains(horse.rfFeet) : true) &&
                    (advancedFeatures.rightBack.count > 0 ? advancedFeatures.rightBack.contains(horse.rrFeet) : true) &&
                    (advancedFeatures.leftFront.count > 0 ? advancedFeatures.leftFront.contains(horse.lfFeet) : true) &&
                    (advancedFeatures.leftBack.count > 0 ? advancedFeatures.leftBack.contains(horse.lrFeet) : true)
            })
            if(advancedFeatures.Color.count > 0 || advancedFeatures.Face.count > 0 || advancedFeatures.Mane.count > 0 || advancedFeatures.Whorl.count > 0 || advancedFeatures.rightFront.count > 0 || advancedFeatures.rightBack.count > 0 || advancedFeatures.leftFront.count > 0 || advancedFeatures.leftBack.count > 0) {
                isSearching = true
            } else {
                isSearching = false
            }
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
        

            filteredData = data.filter({ horse -> Bool in
                return
                    (advancedFeatures.Color.count > 0 ? advancedFeatures.Color.contains(horse.Color) : true) &&
                    (advancedFeatures.Face.count > 0 ? advancedFeatures.Face.contains(horse.Face) : true) &&
                    (advancedFeatures.Mane.count > 0 ? advancedFeatures.Mane.contains(horse.Mane) : true) &&
                    (advancedFeatures.Whorl.count > 0 ? advancedFeatures.Whorl.contains(horse.Whorl) : true) &&
                    (advancedFeatures.rightFront.count > 0 ? advancedFeatures.rightFront.contains(horse.rfFeet) : true) &&
                    (advancedFeatures.rightBack.count > 0 ? advancedFeatures.rightBack.contains(horse.rrFeet) : true) &&
                    (advancedFeatures.leftFront.count > 0 ? advancedFeatures.leftFront.contains(horse.lfFeet) : true) &&
                    (advancedFeatures.leftBack.count > 0 ? advancedFeatures.leftBack.contains(horse.lrFeet) : true)
            }).filter({ horse -> Bool in
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
    
    func createAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func advancedPassBack(userInput: Features) {
        advancedFeatures = userInput
                
        count = advancedFeatures.Color.count + advancedFeatures.Mane.count +
            advancedFeatures.Face.count + advancedFeatures.Whorl.count +
            advancedFeatures.rightFront.count + advancedFeatures.rightBack.count +
            advancedFeatures.leftFront.count + advancedFeatures.leftBack.count
        
        if(count > 0) {
            AdvancedButton?.addBadge(text: String(count))
            isSearching = true
            filteredData = data.filter({ horse -> Bool in
                return
                    (advancedFeatures.Color.count > 0 ? advancedFeatures.Color.contains(horse.Color) : true) &&
                    (advancedFeatures.Face.count > 0 ? advancedFeatures.Face.contains(horse.Face) : true) &&
                    (advancedFeatures.Mane.count > 0 ? advancedFeatures.Mane.contains(horse.Mane) : true) &&
                    (advancedFeatures.Whorl.count > 0 ? advancedFeatures.Whorl.contains(horse.Whorl) : true) &&
                    (advancedFeatures.rightFront.count > 0 ? advancedFeatures.rightFront.contains(horse.rfFeet) : true) &&
                    (advancedFeatures.rightBack.count > 0 ? advancedFeatures.rightBack.contains(horse.rrFeet) : true) &&
                    (advancedFeatures.leftFront.count > 0 ? advancedFeatures.leftFront.contains(horse.lfFeet) : true) &&
                    (advancedFeatures.leftBack.count > 0 ? advancedFeatures.leftBack.contains(horse.lrFeet) : true)
            })
            tableView.reloadData()
        } else {
            filteredData = data
            tableView.reloadData()
            isSearching = false
            AdvancedButton?.removeBadge()
        }
    }
}
          
