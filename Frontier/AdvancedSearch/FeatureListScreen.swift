//
//  FeatureListScreen.swift
//  AdvancedSearch
//
//  Created by Frontier Companion on 1/9/20.
//  Copyright © 2020 Frontier Companion. All rights reserved.
//

import UIKit

class FeatureListScreen: UIViewController,CanRecieve {
    
    func passDataBack(currFeature: String, data: [String]) {
        print ("Features from " + currFeature + ":")
        for element in data {
            print(element)
        }
        switch currFeature {
        
        case "color":
            colorFeatures = data
        case "mane":
            maneFeatures = data
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
        //Update table to display active filters
        self.tableView.reloadData()
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    var features: [Feature] = []
    var selectedFeature = ""
    
    var colorFeatures: [String] = []
    var maneFeatures: [String] = []
    var faceFeatures: [String] = []
    var whorlFeatures: [String] = []
    var rfFeetFeatures: [String] = []
    var rrFeetFeatures: [String] = []
    var lfFeetFeatures: [String] = []
    var lrFeetFeatures: [String] = []
    
    func passDataBack(date: String){
        
    }
    
    override func viewDidLoad() {
        navigationItem.title = "Advanced Search"
        
        super.viewDidLoad()

        features = createArray()
        // Do any additional setup after loading the view.
    }
    
    func createArray() -> [Feature] {
        var tempFeatures: [Feature] = []
        
        let feature1 = Feature(image: UIImage(named:"color")! ,title: "Color",  selection: "")
        let feature2 = Feature(image: UIImage(named:"mane")! ,title: "Mane",  selection: "")
        let feature3 = Feature(image: UIImage(named:"face")! ,title: "Face",  selection: "")
        let feature4 = Feature(image: UIImage(named:"whorl")! ,title: "Whorl",  selection: "")
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
    
}

extension FeatureListScreen: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feature = features[indexPath.row]
        
        let currFeature = feature.title
        
        switch currFeature {
                case "Color":
                    if colorFeatures.count != 0{
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
        
        performSegue(withIdentifier: "showColors", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let secondVC = segue.destination as! ViewController
        secondVC.currFeature = selectedFeature
        
        switch selectedFeature {
            
            case "color":
                secondVC.data = colorFeatures
            case "mane":
                secondVC.data = maneFeatures
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
    
}
