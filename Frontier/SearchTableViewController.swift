//
//  SearchTableViewController.swift
//  Frontier
//
//  Created by Lee Bryant on 11/25/19.
//  Copyright © 2019 Lee Bryant. All rights reserved.
//

import UIKit
struct data {
    
}
struct BaseHorse: Decodable {
    var type: String
    var name: String
    var database: String
    var data: [NameBandHerd]
}

struct NameBandHerd: Decodable {
   var ID: String
   var Name: String
   var herd: String
   var bands: String
}

struct HorsePhotos: Decodable {
    var type: String
    var name: String
    var database: String
    var data: [Photo]
}

struct Photo: Decodable {
   var ID: String
   var ImageFile: String
}

//
//struct HorseData: Decodable {
//    var id: Int
//    var Name: String
//    var Image: String
//    var Band: Int
//    var Color: String
//    var Mane: String
//    var Face: String
//    var Whorl: String
//    var rfFeet: String
//    var rrFeet: String
//    var lfFeet: String
//    var lrFeet: String
//    var Location: String
//    var DartStatus: String
//    var DartDate: String
//}

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
    
    // Data Setup
    var BaseHorseData = [BaseHorse]()
    var FilteredBaseData = [BaseHorse]()
    var HorsePictures = [HorsePhotos]()
    
    var advancedFeatures = Features(Color: [], Mane: [], Face: [], Whorl: [], rightFront: [], rightBack: [], leftFront: [], leftBack: [])
    var count = 0
    var loaded = false
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
        
        parseHorseJSON(withCompletion: { horseData, error in
            if error != nil {
                print(error!)
                self.createAlert(title: "Error", message: "Error loading horse data")
            } else if let horseData = horseData {
                self.parseHorsePicturesJSON(withCompletion: { horsePictures, error in
                    if error != nil {
                        print(error!)
                        self.createAlert(title: "Error", message: "Error loading horse data")
                    } else if let horsePictures = horsePictures {
                        self.BaseHorseData = horseData
                        self.FilteredBaseData = horseData
                        self.HorsePictures = horsePictures
                        self.loadComplete()
                    }
                })
            }
        })
    }

    func loadComplete() {
       DispatchQueue.main.async {
            self.loaded = true
            self.BaseHorseData[0].data.sort(by: {$0.Name < $1.Name})
            self.FilteredBaseData[0].data.sort(by: {$0.Name < $1.Name})
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(loaded) {
            if isSearching {
                return FilteredBaseData[0].data.count
            }
            
            return BaseHorseData[0].data.count
        }
        
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if isSearching {
            cell.textLabel?.text = FilteredBaseData[0].data[indexPath.row].Name
            cell.detailTextLabel?.text = FilteredBaseData[0].data[indexPath.row].bands
        } else {
            cell.textLabel?.text = BaseHorseData[0].data[indexPath.row].Name
            cell.detailTextLabel?.text = "Band: " + BaseHorseData[0].data[indexPath.row].bands
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = Int(FilteredBaseData[0].data[indexPath.row].ID)!
        print(selectedIndex)
        performSegue(withIdentifier: "horseView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "horseView":
                let vc = segue.destination as! HorseViewController
                vc.BaseHorseData = BaseHorseData
                vc.filteredBands = BaseHorseData
                vc.HorseData = BaseHorseData[0].data.filter({ (horse) -> Bool in
                    return Int(horse.ID)! == selectedIndex
                })[0]
                vc.HorseImageData = HorsePictures
                vc.imageArray = HorsePictures[0].data.filter({ (Photo) -> Bool in
                    return Int(Photo.ID)! == selectedIndex
                })
            break
            case "showAdvanced":
                let vc = segue.destination as! FeatureListScreen
                vc.selectedFeatures = advancedFeatures
                vc.delegate = self
            break
            default: break
            // Unreachable
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text?.trimmingCharacters(in: .whitespaces) == "" {
            //Always make filteredData a copy of data when there is no filter applied
            FilteredBaseData[0].data = BaseHorseData[0].data.filter({ horse -> Bool in
                return true
//                    (advancedFeatures.Color.count > 0 ? advancedFeatures.Color.contains(horse.Color) : true) &&
//                    (advancedFeatures.Face.count > 0 ? advancedFeatures.Face.contains(horse.Face) : true) &&
//                    (advancedFeatures.Mane.count > 0 ? advancedFeatures.Mane.contains(horse.Mane) : true) &&
//                    (advancedFeatures.Whorl.count > 0 ? advancedFeatures.Whorl.contains(horse.Whorl) : true) &&
//                    (advancedFeatures.rightFront.count > 0 ? advancedFeatures.rightFront.contains(horse.rfFeet) : true) &&
//                    (advancedFeatures.rightBack.count > 0 ? advancedFeatures.rightBack.contains(horse.rrFeet) : true) &&
//                    (advancedFeatures.leftFront.count > 0 ? advancedFeatures.leftFront.contains(horse.lfFeet) : true) &&
//                    (advancedFeatures.leftBack.count > 0 ? advancedFeatures.leftBack.contains(horse.lrFeet) : true)
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
        

            FilteredBaseData[0].data = BaseHorseData[0].data.filter({ horse -> Bool in
                return true
//                    (advancedFeatures.Color.count > 0 ? advancedFeatures.Color.contains(horse.Color) : true) &&
//                    (advancedFeatures.Face.count > 0 ? advancedFeatures.Face.contains(horse.Face) : true) &&
//                    (advancedFeatures.Mane.count > 0 ? advancedFeatures.Mane.contains(horse.Mane) : true) &&
//                    (advancedFeatures.Whorl.count > 0 ? advancedFeatures.Whorl.contains(horse.Whorl) : true) &&
//                    (advancedFeatures.rightFront.count > 0 ? advancedFeatures.rightFront.contains(horse.rfFeet) : true) &&
//                    (advancedFeatures.rightBack.count > 0 ? advancedFeatures.rightBack.contains(horse.rrFeet) : true) &&
//                    (advancedFeatures.leftFront.count > 0 ? advancedFeatures.leftFront.contains(horse.lfFeet) : true) &&
//                    (advancedFeatures.leftBack.count > 0 ? advancedFeatures.leftBack.contains(horse.lrFeet) : true)
            }).filter({ horse -> Bool in
                guard let text = searchBar.text else { return false }

                let textArr = text.trimmingCharacters(in: .whitespaces).lowercased().components(separatedBy: " ")
                //Variable to keep track of if a horse matches any features
                var retHorse = false

                //Loop through all inputted features and see if current horse fits any of them
                //If current horse matches a searched filter, retHorse will be set to true and then then add the current to the filtered array
                for myText in textArr {
                    retHorse =  horse.Name.lowercased().contains(myText.lowercased()) || horse.bands.lowercased().contains(myText.lowercased())
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
    
    func parseHorseJSON(withCompletion completion: @escaping ([BaseHorse]?, Error?) -> Void) {
        let jsonUrlString = "https://projectfrontier.dev/data/NameHerdBand.json"
            guard let url = URL(string: jsonUrlString) else { return }
            
        let task = URLSession.shared.dataTask(with: url) { (horseData, response, err) in
            guard let horseData = horseData else { return }
            do {
                let horses = try JSONDecoder().decode([BaseHorse].self, from: horseData)
                completion(horses, nil)
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
               completion(nil, err)
            }
        }
        
        task.resume()
    }
    
    func parseHorsePicturesJSON(withCompletion completion: @escaping ([HorsePhotos]?, Error?) -> Void) {
        let jsonUrlString = "https://projectfrontier.dev/data/HorsesPhotos.json"
            guard let url = URL(string: jsonUrlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { (horsePictures, response, err) in
            guard let horsePictures = horsePictures else { return }
            do {
                let data = try JSONDecoder().decode([HorsePhotos].self, from: horsePictures)
                completion(data, nil)
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
            FilteredBaseData[0].data = BaseHorseData[0].data.filter({ horse -> Bool in
                return false
//                    (advancedFeatures.Color.count > 0 ? advancedFeatures.Color.contains(horse.Color) : true) &&
//                    (advancedFeatures.Face.count > 0 ? advancedFeatures.Face.contains(horse.Face) : true) &&
//                    (advancedFeatures.Mane.count > 0 ? advancedFeatures.Mane.contains(horse.Mane) : true) &&
//                    (advancedFeatures.Whorl.count > 0 ? advancedFeatures.Whorl.contains(horse.Whorl) : true) &&
//                    (advancedFeatures.rightFront.count > 0 ? advancedFeatures.rightFront.contains(horse.rfFeet) : true) &&
//                    (advancedFeatures.rightBack.count > 0 ? advancedFeatures.rightBack.contains(horse.rrFeet) : true) &&
//                    (advancedFeatures.leftFront.count > 0 ? advancedFeatures.leftFront.contains(horse.lfFeet) : true) &&
//                    (advancedFeatures.leftBack.count > 0 ? advancedFeatures.leftBack.contains(horse.lrFeet) : true)
            })
            tableView.reloadData()
        } else {
            FilteredBaseData = BaseHorseData
            tableView.reloadData()
            isSearching = false
            AdvancedButton?.removeBadge()
        }
    }
}
          
