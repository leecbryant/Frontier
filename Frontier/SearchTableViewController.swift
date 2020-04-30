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
    var data: [NameBandHerd]
}

struct NameBandHerd: Decodable {
   var ID: Int?
   var Name: String
   var herd: String
   var bands: String
   var Status: String
}

struct HorsePhotos: Decodable {
    var data: [Photo]
}

struct Photo: Decodable {
    var ID: Int?
    var HorseID: Int?
    var ImageFile: String
}

struct HorseTreatments: Decodable {
    var data: [Treatment]
}

struct Treatment: Decodable {
    var id: Int?
   var HorseID: Int?
   var Date: String
   var Action: String
}

struct HorseMarkings: Decodable {
    var data: [Marking]
}

struct Marking: Decodable {
    var HorseID: Int?
    var color: String
    var Position: String?
    var Mane_Color: String?
    var LFMarking: String?
    var RFMarking: String?
    var LHMarking: String?
    var RHMarking: String?
    var FaceString: String?
}


struct Features {
    var Color: [String]
    var Mane: [String]
    var ManePosition: [String]
    var Face: [String]
    var Whorl: [String]
    var rightFront: [String]
    var rightBack: [String]
    var leftFront: [String]
    var leftBack: [String]
}


var selectedIndex = 0

class SearchTableViewController: UITableViewController, UISearchBarDelegate, PassDataToSearch, PassNewToSearch, PassEditToSearch {
    
    @IBOutlet weak var AdvancedButton: UIBarButtonItem!
    
    // Data Setup
    var BaseHorseData: BaseHorse = BaseHorse(data: [NameBandHerd]())
    var FilteredBaseData: BaseHorse = BaseHorse(data: [NameBandHerd]())
    var HorsePictures:HorsePhotos = HorsePhotos(data: [Photo]())
    var HorseLedger: HorseTreatments = HorseTreatments(data: [Treatment]())
    var HorseAttributes: HorseMarkings = HorseMarkings(data: [Marking]())
    var FilteredAttributes: HorseMarkings = HorseMarkings(data: [Marking]())

    var advancedFeatures = Features(Color: [], Mane: [], ManePosition: [], Face: [], Whorl: [], rightFront: [], rightBack: [], leftFront: [], leftBack: [])
    var count = 0
    var loaded = false
    var isSearching = false
        
    // Loading Circle
    var activityView: UIActivityIndicatorView?
    var ReloadData = true
    override func viewDidLoad() {

        super.viewDidLoad()
        navigationItem.title = "Horses"
        
//        loadData()
        
//        showSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BaseHorseData.data = [NameBandHerd]()
        FilteredBaseData.data = [NameBandHerd]()
        tableView.reloadData()
        
        loadData()
        
        showSearchBar()
    }

    
    func editPassBack(response: Bool) {
        if response {
            
        }
    }

    func loadData() {
        showActivityIndicator()
        UIApplication.shared.beginIgnoringInteractionEvents()
        // Grab Data from EACH URL - Should eventually become a SQL Left Join
        parseHorseJSON(withCompletion: { horseData, error in
            if error != nil {
                print(error!)
                self.createAlert(title: "Error", message: "Error loading horse data")
            } else if let horseData = horseData {
                self.parseHorsePicturesJSON(withCompletion: { horsePictures, error in
                    if error != nil {
                        print(error!)
                        self.createAlert(title: "Error", message: "Error loading horse picture data")
                    } else if let horsePictures = horsePictures {
                        self.parseHorseTreatmentJSON(withCompletion: { horseTreatments, error in
                            if error != nil {
                                print(error!)
                                self.createAlert(title: "Error", message: "Error loading horse treatment data")
                            } else if let horseTreatments = horseTreatments {
                                self.parseHorseMarkingsJSON(withCompletion: { horseMarkings, error in
                                    if error != nil {
                                        print(error!)
                                        self.createAlert(title: "Error", message: "Error loading horse treatment data")
                                    } else if let horseMarkings = horseMarkings {
                                        let advancedcount = self.advancedFeatures.Color.count + self.advancedFeatures.ManePosition.count + self.advancedFeatures.Mane.count +
                                            self.advancedFeatures.Face.count + self.advancedFeatures.Whorl.count +
                                            self.advancedFeatures.rightFront.count + self.advancedFeatures.rightBack.count +
                                            self.advancedFeatures.leftFront.count + self.advancedFeatures.leftBack.count
                                        self.BaseHorseData = horseData
                                        self.HorsePictures = horsePictures
                                        self.HorseLedger = horseTreatments
                                        self.HorseAttributes = horseMarkings
                                        self.FilteredAttributes = horseMarkings
                                        if(advancedcount == 0) {
                                            self.FilteredBaseData = horseData
                                        } else {
                                            self.isSearching = true
                                            self.FilteredAttributes.data = self.HorseAttributes.data.filter ({ horsemark -> Bool in
                                                return ((self.advancedFeatures.Color.count > 0 ? self.advancedFeatures.Color.contains(horsemark.color) : true)) &&
                                                    (self.advancedFeatures.ManePosition.count > 0 ? horsemark.Position != nil ? self.advancedFeatures.ManePosition.contains(horsemark.Position!) : false : true) &&
                                                    (self.advancedFeatures.Mane.count > 0 ? horsemark.Mane_Color != nil ? self.advancedFeatures.Mane.contains(horsemark.Mane_Color!) : false : true) &&
                                                    (self.advancedFeatures.Face.count > 0 ? horsemark.FaceString != nil ? self.advancedFeatures.Face.contains(horsemark.FaceString!) : false : true) &&
                                                    (self.advancedFeatures.rightFront.count > 0 ? horsemark.RFMarking != nil ? self.advancedFeatures.rightFront.contains(horsemark.RFMarking!) : false : true) &&
                                                    (self.advancedFeatures.rightBack.count > 0 ? horsemark.RHMarking != nil ? self.advancedFeatures.rightBack.contains(horsemark.RHMarking!) : false : true) &&
                                                    (self.advancedFeatures.leftFront.count > 0 ? horsemark.LFMarking != nil ? self.advancedFeatures.leftFront.contains(horsemark.LFMarking!) : false : true) &&
                                                    (self.advancedFeatures.leftBack.count > 0 ? horsemark.LHMarking != nil ? self.advancedFeatures.leftBack.contains(horsemark.LHMarking!) : false : true)
                                              })
                                            self.FilteredBaseData.data = self.BaseHorseData.data.filter({ (horse) -> Bool in
                                                return self.FilteredAttributes.data.contains { (mark) -> Bool in
                                                    return horse.ID == mark.HorseID!
                                                }
                                            })
                                        }
                                        self.loadComplete()
                                    }
                                })
                            }
                        })
                    }
                })
            }
        })
    }
    
    func loadComplete() {
       DispatchQueue.main.async {
            self.loaded = true
            self.BaseHorseData.data.sort(by: {$0.Name < $1.Name})
            self.FilteredBaseData.data.sort(by: {$0.Name < $1.Name})
            self.hideActivityIndicator()
            UIApplication.shared.endIgnoringInteractionEvents()
            self.tableView.reloadData()
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
       }
    }
    
    func showActivityIndicator() {
        activityView = UIActivityIndicatorView()
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }

    func hideActivityIndicator(){
        if (activityView != nil){
            activityView?.stopAnimating()
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
        searchController.searchBar.placeholder = "Search horse by name or location..."
        searchController.searchBar.showsCancelButton = false
//        searchController.searchBar.showsBookmarkButton = true
//        searchController.searchBar.setImage(UIImage(named: "advanced"), for: .bookmark, state: .disabled)
        navigationItem.searchController = searchController
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(loaded) {
            if isSearching {
                return FilteredBaseData.data.count
            }
            
            return BaseHorseData.data.count
        }
        
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if isSearching {
            cell.textLabel?.text = FilteredBaseData.data[indexPath.row].Name
            cell.detailTextLabel?.text = FilteredBaseData.data[indexPath.row].herd
        } else {
            cell.textLabel?.text = BaseHorseData.data[indexPath.row].Name
            cell.detailTextLabel?.text = "Location: " + BaseHorseData.data[indexPath.row].herd
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = FilteredBaseData.data[indexPath.row].ID!
            performSegue(withIdentifier: "horseView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "horseView":
                let vc = segue.destination as! HorseViewController
                vc.BaseHorseData = BaseHorseData
                vc.filteredBands = BaseHorseData
                vc.HorseData = BaseHorseData.data.filter({ (horse) -> Bool in
                    return horse.ID! == selectedIndex
                })[0]
                vc.HorseImageData = HorsePictures
                vc.imageArray = HorsePictures.data.filter({ (Photo) -> Bool in
                    return Photo.HorseID! == selectedIndex
                })
                vc.HorseLedger = HorseLedger
                vc.HorseDartData = HorseLedger.data.sorted(by: {$0.Date > $1.Date}).filter{ (Horse) -> Bool in
                    return Horse.HorseID! == selectedIndex
                }
                vc.HorseAttributes = HorseAttributes
                vc.HorseMarkingData = HorseAttributes.data.filter{ (Horse) -> Bool in
                    return Horse.HorseID! == selectedIndex
                }[0]
                vc.delegate = self
            break
            case "showAdvanced":
                let vc = segue.destination as! FeatureListScreen
                vc.selectedFeatures = advancedFeatures
                vc.delegate = self
            break
            case "showNew":
                let vc = segue.destination as! NewHorse
                vc.delegate = self
            break
            default: break
            // Unreachable
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text?.trimmingCharacters(in: .whitespaces) == "" {
            //Always make filteredData a copy of data when there is no filter applied
              FilteredAttributes.data = HorseAttributes.data.filter ({ horsemark -> Bool in
                      return ((advancedFeatures.Color.count > 0 ? advancedFeatures.Color.contains(horsemark.color) : true)) &&
                          (advancedFeatures.ManePosition.count > 0 ? horsemark.Position != nil ? advancedFeatures.ManePosition.contains(horsemark.Position!) : false : true)  &&
                          (advancedFeatures.Mane.count > 0 ? horsemark.Mane_Color != nil ? advancedFeatures.Mane.contains(horsemark.Mane_Color!) : false : true) &&
                          (advancedFeatures.Face.count > 0 ? horsemark.FaceString != nil ? advancedFeatures.Face.contains(horsemark.FaceString!) : false : true) &&
                          (advancedFeatures.rightFront.count > 0 ? horsemark.RFMarking != nil ? advancedFeatures.rightFront.contains(horsemark.RFMarking!) : false : true) &&
                          (advancedFeatures.rightBack.count > 0 ? horsemark.RHMarking != nil ? advancedFeatures.rightBack.contains(horsemark.RHMarking!) : false : true) &&
                          (advancedFeatures.leftFront.count > 0 ? horsemark.LFMarking != nil ? advancedFeatures.leftFront.contains(horsemark.LFMarking!) : false : true) &&
                          (advancedFeatures.leftBack.count > 0 ? horsemark.LHMarking != nil ? advancedFeatures.leftBack.contains(horsemark.LHMarking!) : false : true)
                })
              FilteredBaseData.data = BaseHorseData.data.filter({ (horse) -> Bool in
                  return FilteredAttributes.data.contains { (mark) -> Bool in
                      return horse.ID == mark.HorseID
                  }
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
        

            FilteredAttributes.data = HorseAttributes.data.filter ({ horsemark -> Bool in
                    return ((advancedFeatures.Color.count > 0 ? advancedFeatures.Color.contains(horsemark.color) : true)) &&
                    (advancedFeatures.ManePosition.count > 0 ? horsemark.Position != nil ? advancedFeatures.ManePosition.contains(horsemark.Position!) : false : true) &&
                        (advancedFeatures.Mane.count > 0 ? horsemark.Mane_Color != nil ? advancedFeatures.Mane.contains(horsemark.Mane_Color!) : false : true) &&
                        (advancedFeatures.Face.count > 0 ? horsemark.FaceString != nil ? advancedFeatures.Face.contains(horsemark.FaceString!) : false : true) &&
                        (advancedFeatures.rightFront.count > 0 ? horsemark.RFMarking != nil ? advancedFeatures.rightFront.contains(horsemark.RFMarking!) : false : true) &&
                        (advancedFeatures.rightBack.count > 0 ? horsemark.RHMarking != nil ? advancedFeatures.rightBack.contains(horsemark.RHMarking!) : false : true) &&
                        (advancedFeatures.leftFront.count > 0 ? horsemark.LFMarking != nil ? advancedFeatures.leftFront.contains(horsemark.LFMarking!) : false : true) &&
                        (advancedFeatures.leftBack.count > 0 ? horsemark.LHMarking != nil ? advancedFeatures.leftBack.contains(horsemark.LHMarking!) : false : true)
              })
              FilteredBaseData.data = BaseHorseData.data.filter({ (horse) -> Bool in
                    return FilteredAttributes.data.contains { (mark) -> Bool in
                        return horse.ID == mark.HorseID!
                    }
                }).filter({ horse -> Bool in
                guard let text = searchBar.text else { return false }

                let textArr = text.trimmingCharacters(in: .whitespaces).lowercased().components(separatedBy: " ")
                //Variable to keep track of if a horse matches any features
                var retHorse = false

                //Loop through all inputted features and see if current horse fits any of them
                //If current horse matches a searched filter, retHorse will be set to true and then then add the current to the filtered array
                for myText in textArr {
                    retHorse =  horse.Name.lowercased().contains(myText.lowercased()) || horse.herd.lowercased().contains(myText.lowercased())
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
    
    @IBAction func showNew(_ sender: Any) {
        performSegue(withIdentifier: "showNew", sender: self)
    }
    
    
    func parseHorseJSON(withCompletion completion: @escaping (BaseHorse?, Error?) -> Void) {
        // Begin Call
        let url = URL(string: Constants.config.apiLink + "api/base/horses")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                guard let data = data else {return}
                do {
                    print(data)
                    let horses = try JSONDecoder().decode(BaseHorse.self, from: data)
                    completion(horses, nil)
                } catch let jsonErr {
                    print(jsonErr)
               }
         
        }
        task.resume()
    }
    
    func parseHorsePicturesJSON(withCompletion completion: @escaping (HorsePhotos?, Error?) -> Void) {
        // Begin Call
        let url = URL(string: Constants.config.apiLink + "api/base/horseimages")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                guard let data = data else {return}
                do {
                    print(data)
                    let horses = try JSONDecoder().decode(HorsePhotos.self, from: data)
                    completion(horses, nil)
                } catch let jsonErr {
                    print(jsonErr)
               }
         
        }
        task.resume()
    }
    
    func parseHorseTreatmentJSON(withCompletion completion: @escaping (HorseTreatments?, Error?) -> Void) {
        // Begin Call
        let url = URL(string: Constants.config.apiLink + "api/base/horsetreatments")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                guard let data = data else {return}
                do {
                    print(data)
                    let horses = try JSONDecoder().decode(HorseTreatments.self, from: data)
                    completion(horses, nil)
                } catch let jsonErr {
                    print(jsonErr)
               }
         
        }
        task.resume()
    }
    
    func parseHorseMarkingsJSON(withCompletion completion: @escaping (HorseMarkings?, Error?) -> Void) {
        // Begin Call
        let url = URL(string: Constants.config.apiLink + "api/base/horsemarkings")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                guard let data = data else {return}
                do {
                    print(data)
                    let horses = try JSONDecoder().decode(HorseMarkings.self, from: data)
                    completion(horses, nil)
                } catch let jsonErr {
                    print(jsonErr)
               }
         
        }
        task.resume()
    }
    
    func createAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func newPassBack(response: Bool) {
        if response {
            loadData()
        }
    }
    
    func advancedPassBack(userInput: Features) {
        ReloadData = false
        advancedFeatures = userInput
                
        count = advancedFeatures.Color.count + advancedFeatures.ManePosition.count + advancedFeatures.Mane.count +
            advancedFeatures.Face.count + advancedFeatures.Whorl.count +
            advancedFeatures.rightFront.count + advancedFeatures.rightBack.count +
            advancedFeatures.leftFront.count + advancedFeatures.leftBack.count
        
        if(count > 0) {
            AdvancedButton?.addBadge(text: String(count))
            isSearching = true
            FilteredAttributes.data = HorseAttributes.data.filter ({ horsemark -> Bool in
                    return ((advancedFeatures.Color.count > 0 ? advancedFeatures.Color.contains(horsemark.color) : true)) &&
                        (advancedFeatures.ManePosition.count > 0 ? horsemark.Position != nil ? advancedFeatures.ManePosition.contains(horsemark.Position!) : false : true) &&
                        (advancedFeatures.Mane.count > 0 ? horsemark.Mane_Color != nil ? advancedFeatures.Mane.contains(horsemark.Mane_Color!) : false : true) &&
                        (advancedFeatures.Face.count > 0 ? horsemark.FaceString != nil ? advancedFeatures.Face.contains(horsemark.FaceString!) : false : true) &&
                        (advancedFeatures.rightFront.count > 0 ? horsemark.RFMarking != nil ? advancedFeatures.rightFront.contains(horsemark.RFMarking!) : false : true) &&
                        (advancedFeatures.rightBack.count > 0 ? horsemark.RHMarking != nil ? advancedFeatures.rightBack.contains(horsemark.RHMarking!) : false : true) &&
                        (advancedFeatures.leftFront.count > 0 ? horsemark.LFMarking != nil ? advancedFeatures.leftFront.contains(horsemark.LFMarking!) : false : true) &&
                        (advancedFeatures.leftBack.count > 0 ? horsemark.LHMarking != nil ? advancedFeatures.leftBack.contains(horsemark.LHMarking!) : false : true)
              })
            FilteredBaseData.data = BaseHorseData.data.filter({ (horse) -> Bool in
                return FilteredAttributes.data.contains { (mark) -> Bool in
                    return horse.ID == mark.HorseID!
                }
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
          
