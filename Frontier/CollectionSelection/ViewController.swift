//
//  ViewController.swift
//  AdvancedSearch
//
//  Created by Frontier Companion on 1/9/20.
//  Copyright © 2020 Frontier Companion. All rights reserved.
//

import UIKit

protocol CanRecieve {
    func passDataBack(currFeature: String, data: [String])
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    var delegate:CanRecieve?
    
    //Data to send back to previous View
    var currFeature: String = ""
    var data: [String] = []
    
    private let sectionInsets = UIEdgeInsets(top:10.0,
                                             left: 10.0,
                                             bottom: 10.0,
                                             right: 0.0)
    private let itemsPerRow: CGFloat = 3
    
    private let relativeFontConstant:CGFloat = 0.046
    
    //Variables to hold the current working collection information
    //Used to dynamically display different collectionviews
    var myLabels: [String] = []
    var myImages: [UIImage] = []
    
    let colors = ["Appaloosa", "Bay", "Bay Roan",
                  "Black", "Blue Roan", "Brown",
                  "Buckskin", "Chestnut", "Cremelo",
                  "Gray", "Palomino", "Pinto","Red Roan"]
    let manes = ["Left", "Right", "Split", "Alternating",
                 "Flaxen", "Black", "Brown", "Gray",
                 "Multicolor","Red", "White", "Body: same",
                 "Body: Lighter", "Body: Darker"]
    let faces = ["None", "Blaze", "Star", "Snip", "Strip"]
    let whorls = ["At Eye Level", "Above Eye Level", "Below Eye Level", "Double", "Neck" ]
    let allFeet = ["none", "coronet", "Pastern", "heel", "fetlock", "tall socks", "stockings", "ermine"]
    
    
    
    
    let colorImages: [UIImage] = [
    
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!
         
    ]
    
    let maneImages: [UIImage] = [
    
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!
         
    ]
    
    let faceImages: [UIImage] = [
    
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!
         
    ]
    
    let whorlImages: [UIImage] = [
    
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!
         
    ]
    
    let feetImages: [UIImage] = [
    
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!,
        UIImage(named: "missing")!
         
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch currFeature {
        case "color":
            myLabels = colors
            myImages = colorImages
        case "mane":
            myLabels = manes
            myImages = maneImages
        case "face":
            myLabels = faces
            myImages = faceImages
        case "whorl":
            myLabels = whorls
            myImages = whorlImages
        case "rfFeet":
            myLabels = allFeet
            myImages = feetImages
        case "rrFeet":
            myLabels = allFeet
            myImages = feetImages
        case "lfFeet":
            myLabels = allFeet
            myImages = feetImages
        case "lrFeet":
            myLabels = allFeet
            myImages = feetImages
        default:
            print("Error: Invalid segue to collectionview")
        }
        
        //Set Font-size of submit button (at bottom) relative to screensize
        submitBtn.titleLabel?.font = submitBtn.titleLabel?.font.withSize(self.view.frame.height * relativeFontConstant)
        
        // Do any additional setup after loading the view.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myLabels.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Define the current cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        //Populate cell with information/formatting
        cell.contentLabel.text = myLabels[indexPath.item]
        cell.contentLabel.font = cell.contentLabel.font.withSize(self.view.frame.height * relativeFontConstant / itemsPerRow)
        cell.contentImageView.image = myImages[indexPath.item]
        
        //Determine Cell-Color based on whether or not a feature is active
        if (data.filter { $0 == cell.contentLabel.text}).count == 1 {
            cell.myView.backgroundColor = .red
        }
        
        //Disable gestures (needed to allow users to click on a cell)
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        
        return cell
    }
    
    
    // Function is ran whenever a user taps on a cell
    @objc func tap(_ sender: UITapGestureRecognizer) {

       let location = sender.location(in: self.collectionView)
       let indexPath = self.collectionView.indexPathForItem(at: location)

        
        
        //Run code here for tapped cell
       if let index = indexPath {
        //print(colors[index.row])
        let cell = self.collectionView.cellForItem(at: index) as! CollectionViewCell
        
        //Code for Selecting a feature
        if data.count == (data.filter { $0 != myLabels[index.row]}).count {
            //Debugging Console
            print("Selecting Feature: " + myLabels[index.row])
            //Add feature to array of selected features
            data.append(myLabels[index.row])
            //Change appearance of cell
            cell.myView.backgroundColor = .red
        }
            //Code for De-Selecting a feature
        else{
            //Debugging Console
            print("Deselecting Feature: " + myLabels[index.row])
            //Remove feature from array of selected features
            data = data.filter{ $0 != myLabels[index.row]}
            
            cell.myView.backgroundColor = .systemBlue
        }
       }
    }
    
    //Dynamically Size each cell relative to screen size
    func collectionView( _ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
      //calculate available screen size
      let paddingSpace = sectionInsets.left  * (itemsPerRow + 1)
      let availableWidth = view.frame.width - paddingSpace
      let widthPerItem = availableWidth / itemsPerRow
        //Assign Cell a width/height
        return CGSize(width: widthPerItem, height: widthPerItem * 1.15)
    }

    //Needed to assign custom insets
    func collectionView( _ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        //sectionInsets is defined at top of code
      return sectionInsets
    }

    // Minimum insets (No overlapping)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return sectionInsets.left
    }
    
    
    @IBAction func submitFeature(_ sender: Any) {
        delegate?.passDataBack(currFeature: currFeature, data: data)
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}


