//
//  FeatureListScreen.swift
//  AdvancedSearch
//
//  Created by Frontier Companion on 1/9/20.
//  Copyright © 2020 Frontier Companion. All rights reserved.
//

import UIKit

protocol PassNewToSearch {
    func newPassBack(response: Bool)
}

class NewHorse: UIViewController, CanRecieve {
    var activityView: UIActivityIndicatorView?
    var delegate: PassNewToSearch?
    var selectedFeatures = Features(Color: [], Mane: [], ManePosition: [], Face: [], Whorl: [], rightFront: [], rightBack: [], leftFront: [], leftBack: [])

    func passDataBack(currFeature: String, data: [String]) {
        switch currFeature {
            case "color":
                colorFeatures = data
            case "mane":
                maneFeatures = data
            case "maneposition":
                manePositionFeatures = data
            case "face":
                faceFeatures = data
            case "whorl":
                whorlFeatures = data
            case "rfFeet":
                rfFeetFeatures = data
            case "rrFeet":
                rrFeetFeatures = data
            case "lfFeet":
                lfFeetFeatures = data
            case "lrFeet":
                lrFeetFeatures = data
                
            default:
                print("Error: invalid feature selection passback")
        }
        self.tableView.reloadData()
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Band: UITextField!
    @IBOutlet weak var Location: UITextField!
    
    
    var backButton : UIBarButtonItem!

    var features: [Feature] = []
    var selectedFeature = ""
    
    var colorFeatures: [String] = []
    var maneFeatures: [String] = []
    var manePositionFeatures: [String] = []
    var faceFeatures: [String] = []
    var whorlFeatures: [String] = []
    var rfFeetFeatures: [String] = []
    var rrFeetFeatures: [String] = []
    var lfFeetFeatures: [String] = []
    var lrFeetFeatures: [String] = []
    
    override func viewDidLoad() {
        navigationItem.title = "New Horse"
        
        super.viewDidLoad()
        
        colorFeatures = selectedFeatures.Color
        maneFeatures = selectedFeatures.Mane
        manePositionFeatures = selectedFeatures.ManePosition
        faceFeatures = selectedFeatures.Face
        whorlFeatures = selectedFeatures.Whorl
        rfFeetFeatures = selectedFeatures.rightFront
        rrFeetFeatures = selectedFeatures.rightBack
        lfFeetFeatures = selectedFeatures.leftFront
        lrFeetFeatures = selectedFeatures.leftBack
        
        features = createArray()
        
        
        // Back Button setup
        self.backButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack(sender:)))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func createArray() -> [Feature] {
        var tempFeatures: [Feature] = []
        
        let feature1 = Feature(image: UIImage(named:"color")! ,title: "Color",  selection: "")
        let feature2 = Feature(image: UIImage(named:"mane")! ,title: "Mane",  selection: "")
        let feature3 = Feature(image: UIImage(named:"mane")! ,title: "Mane Position",  selection: "")
        let feature4 = Feature(image: UIImage(named:"face")! ,title: "Face",  selection: "")
        let feature5 = Feature(image: UIImage(named:"feet")! ,title: "Right Front",  selection: "")
        let feature6 = Feature(image: UIImage(named:"feet")! ,title: "Right Rear",  selection: "")
        let feature7 = Feature(image: UIImage(named:"feet")! ,title: "Left Front",  selection: "")
        let feature8 = Feature(image: UIImage(named:"feet")! ,title: "Left Rear",  selection: "")
        tempFeatures.append(feature1)
        tempFeatures.append(feature2)
        tempFeatures.append(feature3)
        tempFeatures.append(feature4)
        tempFeatures.append(feature5)
        tempFeatures.append(feature6)
        tempFeatures.append(feature7)
        tempFeatures.append(feature8)
        
        return tempFeatures
    }
    
    
    @objc func goBack(sender: UIBarButtonItem) {
        let count = colorFeatures.count + maneFeatures.count + manePositionFeatures.count +
        faceFeatures.count + whorlFeatures.count +
        rfFeetFeatures.count + rrFeetFeatures.count +
        lfFeetFeatures.count + lrFeetFeatures.count
        if(count > 0) {
            let refreshAlert = UIAlertController(title: "Cancel", message: "Are you sure you want to cancel? All unsaved selections will be lost.", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action: UIAlertAction!) in
                self.navigationController?.popViewController(animated: true)
            }))

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                // Do nothing
            }))

            present(refreshAlert, animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
           let secondVC = segue.destination as! ViewController
           secondVC.currFeature = selectedFeature
           
           switch selectedFeature {
               
               case "color":
                   secondVC.data = colorFeatures
               case "mane":
                   secondVC.data = maneFeatures
               case "maneposition":
                    secondVC.data = manePositionFeatures
               case "face":
                   secondVC.data = faceFeatures
               case "whorl":
                   secondVC.data = whorlFeatures
               case "rfFeet":
                   secondVC.data = rfFeetFeatures
               case "rrFeet":
                   secondVC.data = rrFeetFeatures
               case "lfFeet":
                   secondVC.data = lfFeetFeatures
               case "lrFeet":
                   secondVC.data = lrFeetFeatures
               default:
                   print("Error: transfering saved features to collection view")
               
           }
           
           
           secondVC.delegate = self
       }
       
       @IBAction func onSubmit(_ sender: Any) {
        struct SubmitFeatures: Codable {
            var Color: String?
            var Mane: String?
            var ManePosition: String?
            var Whorl: String?
            var Face: String?
            var rightFront: String?
            var rightBack: String?
            var leftFront: String?
            var leftBack: String?
        }
        let selectedFeatures = SubmitFeatures(Color: colorFeatures.count > 0 ? colorFeatures[0] : nil, Mane: maneFeatures.count > 0 ? maneFeatures[0] : nil, ManePosition: manePositionFeatures.count > 0 ? manePositionFeatures[0] : nil, Whorl: whorlFeatures.count > 0 ? whorlFeatures[0] : nil, Face: faceFeatures.count > 0 ? faceFeatures[0] : nil, rightFront: rfFeetFeatures.count > 0 ? rfFeetFeatures[0] : nil, rightBack: rrFeetFeatures.count > 0 ? rrFeetFeatures[0] : nil, leftFront: lfFeetFeatures.count > 0 ? lfFeetFeatures[0] : nil, leftBack: lrFeetFeatures.count > 0 ? lrFeetFeatures[0] : nil)
        
        struct SubmitObj: Codable {
            var Name: String?
            var BandName: String?
            var Location: String?
            var Features: SubmitFeatures
        }
        
        let submit = SubmitObj(Name: Name.text, BandName: Band.text, Location: Location.text, Features: selectedFeatures)
        
        if Name.text == "" || Band.text == "" || Location.text == "" {
            createAlert(title: "Error", message: "Name, Band, and Location must be filled out.")
        } else if colorFeatures.count > 0 {
            // Stop everything to load
            UIApplication.shared.beginIgnoringInteractionEvents()
            showActivityIndicator()
            // Data Structs
            struct ReturnModel: Codable {
                var success: Bool?
            }
            // Begin Call
            let url = URL(string: Constants.config.apiLink + "api/base/horses")
            guard let requestUrl = url else { fatalError() }
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "POST"
            // Set HTTP Request Header
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let jsonData = try? JSONEncoder().encode(submit)
            request.httpBody = jsonData
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    
                    if let error = error {
                        print("Error took place \(error)")
                        return
                    }
                    guard let data = data else {return}
                    do {
                         let todoItemModel = try JSONDecoder().decode(ReturnModel.self, from: data)
                            DispatchQueue.main.async {
                                UIApplication.shared.endIgnoringInteractionEvents()
                                self.hideActivityIndicator()
                                if todoItemModel.success == false {
                                    self.createAlert(title: "Error", message: "Unable to create new horse record")
                                } else {
                                    self.delegate?.newPassBack(response: todoItemModel.success ?? false)
                                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                    } catch let jsonErr {
                        print(jsonErr)
                   }
             
            }
            task.resume()
        } else {
            createAlert(title: "Error", message: "Horse color must be selected.")
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
    
    func createAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension NewHorse: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feature = features[indexPath.row]
        
        let currFeature = feature.title
        
        switch currFeature {
                case "Color":
                    if colorFeatures.count != 0 {
                        if colorFeatures.count == 1 {
                            feature.selection = colorFeatures[0]
                        } else {
                            feature.selection = "Multiple"
                        }
                    } else {
                        feature.selection = ""
                    }
                case "Mane":
                    if maneFeatures.count != 0{
                        if maneFeatures.count == 1 {
                            feature.selection = maneFeatures[0]
                        } else {
                            feature.selection = "Multiple"
                        }
                    } else {
                        feature.selection = ""
                    }
                case "Mane Position":
                    if manePositionFeatures.count != 0{
                        if manePositionFeatures.count == 1 {
                            feature.selection = manePositionFeatures[0]
                        } else {
                            feature.selection = "Multiple"
                        }
                    } else {
                        feature.selection = ""
                    }
                case "Face":
                    if faceFeatures.count != 0{
                        if faceFeatures.count == 1 {
                            feature.selection = faceFeatures[0]
                        } else {
                            feature.selection = "Multiple"
                        }
                    } else {
                        feature.selection = ""
                    }
                case "Whorl":
                    if whorlFeatures.count != 0{
                        if whorlFeatures.count == 1 {
                            feature.selection = whorlFeatures[0]
                        } else {
                            feature.selection = "Multiple"
                        }
                    } else {
                        feature.selection = ""
                    }
                case "Right Front":
                    if rfFeetFeatures.count != 0{
                        if rfFeetFeatures.count == 1 {
                            feature.selection = rfFeetFeatures[0]
                        } else {
                            feature.selection = "Multiple"
                        }
                    } else {
                        feature.selection = ""
                    }
                case "Right Rear":
                    if rrFeetFeatures.count != 0{
                        if rrFeetFeatures.count == 1 {
                            feature.selection = rrFeetFeatures[0]
                        } else {
                            feature.selection = "Multiple"
                        }
                    } else {
                        feature.selection = ""
                    }
                case "Left Front":
                    if lfFeetFeatures.count != 0{
                        if lfFeetFeatures.count == 1 {
                            feature.selection = lfFeetFeatures[0]
                        } else {
                            feature.selection = "Multiple"
                        }
                    } else {
                        feature.selection = ""
                    }
                case "Left Rear":
                    if lrFeetFeatures.count != 0{
                        if lrFeetFeatures.count == 1 {
                            feature.selection = lrFeetFeatures[0]
                        } else {
                            feature.selection = "Multiple"
                        }
                    } else {
                        feature.selection = ""
                    }
                default:
                    print("Error: selecting a row from feature table")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureCell") as! FeatureCell
        cell.setFeature(feature: feature)
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let myTableSelection = features[indexPath.row].title
       
        
        // If table cell clicked was Color, segue into the Color-picker view
        switch myTableSelection {
            
            case "Color":
                selectedFeature = "color"
            case "Mane":
                selectedFeature = "mane"
            case "Mane Position":
                selectedFeature = "maneposition"
            case "Face":
                selectedFeature = "face"
            case "Whorl":
                selectedFeature = "whorl"
            case "Right Front":
                selectedFeature = "rfFeet"
            case "Right Rear":
                selectedFeature = "rrFeet"
            case "Left Front":
                selectedFeature = "lfFeet"
            case "Left Rear":
                selectedFeature = "lrFeet"
            default:
                print("Error: selecting a row from feature table")
            
        }
        
        performSegue(withIdentifier: "showSelect", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Clear") {
            (action, view, success) in
            self.clearCell(Index: indexPath.row)
            self.tableView.reloadRows(at: [indexPath], with: .none)
            success(true)
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Clear") {
            (action, view, success) in
            self.clearCell(Index: indexPath.row)
            self.tableView.reloadRows(at: [indexPath], with: .none)
            success(true)
        }
        
        return UISwipeActionsConfiguration(actions: [delete])

    }
    
    func clearCell(Index: Int?) {
        let myTableSelection = features[Index ?? 0].title
        
        switch myTableSelection {
             
             case "Color":
                colorFeatures.removeAll()
                selectedFeature = ""
             case "Mane":
                maneFeatures.removeAll()
                selectedFeature = ""
            case "ManePosition":
                manePositionFeatures.removeAll()
                selectedFeature = ""
             case "Face":
                faceFeatures.removeAll()
                selectedFeature = ""
             case "Whorl":
                whorlFeatures.removeAll()
                selectedFeature = ""
             case "Right Front":
                rfFeetFeatures.removeAll()
                selectedFeature = ""
             case "Right Rear":
                rrFeetFeatures.removeAll()
                selectedFeature = ""
             case "Left Front":
                lfFeetFeatures.removeAll()
                selectedFeature = ""
             case "Left Rear":
                lrFeetFeatures.removeAll()
                selectedFeature = ""
             default:
                 print("Error: selecting a row from feature table")
             
         }
        
    }
    
}

