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
        
    var delegate:CanRecieve?
    
    //Data to send back to previous View
    var currFeature: String = ""
    var data: [String] = []
    var backButton : UIBarButtonItem!

    /*private let sectionInsets = UIEdgeInsets(top: 10.0,
                                             left: 10.0,
                                             bottom: 10.0,
                                             right: 10.0)*/
    //private let itemsPerRow: CGFloat = 3
    
    private let relativeFontConstant:CGFloat = 0.046
    
    //Variables to hold the current working collection information
    //Used to dynamically display different collectionviews
    var myLabels: [String] = []
    var myImages: [UIImage] = []
    
    let colors = ["Applaloosa", "Bay", "Bay Roan",
                  "Black", "Blue Roan", "Brown",
                  "Buckskin", "Chestnut", "Cremello",
                  "Gray", "Palomino", "Pinto","Red Roan"]
    let manes = ["Alternating",
                 "Flaxen", "Black", "Brown", "Gray",
                 "Multicolor","Red", "White", "Body Color - Same Shade",
                 "Body Color - Lighter Shade", "Body Color - Darker Shade"]
    let manepositions = ["Left", "Right", "Split"]
    let faces = ["None", "Blaze", "Star", "Snip", "Strip"]
    let whorls = ["At Eye Level", "Above Eye Level", "Below Eye Level", "Double", "Neck" ]
    let allFeet = ["None", "Coronet", "Pastern", "Heel", "Fetlock", "Tall Socks", "Stocking", "Ermine"]
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    let cellSpacing: CGFloat = 5
    let cellsPerRow: CGFloat = 2

    
    
    
    
    func defineCellSize() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        //let cellSize = (collectionView.collectionViewLayout.collectionViewContentSize.width / cellsPerRow) - (cellSpacing)
        
        let cellSize = ((screenWidth-20)/cellsPerRow)-(cellSpacing)
        
        print(cellSize)
        
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = 2*cellSpacing
        collectionView.collectionViewLayout = layout
    }
    
    func setCVConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if data.count > 0 { if data[0] == "" { data = [] } }
        /// Set overall collectionview constraints
        setCVConstraints()
        /// Set the size of each cell relative ot screen size
        defineCellSize()
                    
        
        switch currFeature {
            case "color":
                myLabels = colors
            case "mane":
                myLabels = manes
            case "maneposition":
                myLabels = manepositions
            case "face":
                myLabels = faces
            case "whorl":
                myLabels = whorls
            case "rfFeet":
                myLabels = allFeet
            case "rrFeet":
                myLabels = allFeet
            case "lfFeet":
                myLabels = allFeet
            case "lrFeet":
                myLabels = allFeet
            default:
                print("Error: Invalid segue to collectionview")
        }
        
        // Cancel Button Setup
        self.backButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack(sender:)))
        self.navigationItem.leftBarButtonItem = backButton
        
    }
    
    // Cancel Confirmation
    @objc func goBack(sender: UIBarButtonItem) {
        if(data.count > 0) {
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myLabels.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Define the current cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        /// Dynamically Size Images within CollectionViewCell
        /// From: https://stackoverflow.com/questions/32198069/scale-image-to-fit-ios
        let imageView :UIImageView = {
            let imageView = UIImageView(frame: CGRect(   x: 0,
                                                 y: 0,
                                                 width: (super.view.frame.width / cellsPerRow)
                                                    - (cellSpacing),
                                                 height: (collectionView.collectionViewLayout
                .collectionViewContentSize.width / cellsPerRow)
                - (cellSpacing)))
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            
            // Determine directory for feature images
            var imageDirectory: String = ""

            if (currFeature == "color") {
                imageDirectory = "HorseColor/"
            } else if (currFeature == "mane" || currFeature == "maneposition") {
                imageDirectory = "HorseMane/"
            } else if (currFeature == "face") {
                imageDirectory = "HorseFace/"
            } else if (currFeature == "whorl") {
                imageDirectory = "HorseWhorl/"
            } else if (currFeature == "rfFeet") {
                imageDirectory = "HorseFeet/"
            } else if (currFeature == "rrFeet") {
                imageDirectory = "HorseFeet/"
            } else if (currFeature == "lfFeet") {
                imageDirectory = "HorseFeet/"
            } else if (currFeature == "lrFeet") {
                imageDirectory = "HorseFeet/"
            }
            
            let individualImage = myLabels[indexPath.item].lowercased().filter{!" \n\t\r".contains($0)}
            imageView.image = UIImage(named: ("AdvancedFeatureImages/" + imageDirectory + individualImage))
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        /// Add label below image
        let label: UILabel = {
            let label = UILabel()
            label.text = myLabels[indexPath.item]
            label.numberOfLines = 1
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.2
            label.sizeToFit()
            label.contentMode = UIView.ContentMode.scaleAspectFit
            label.lineBreakMode = .byTruncatingTail
            return label
        }()
        
        let verticalStackView: UIStackView = {
           let stackView = UIStackView(arrangedSubviews: [imageView, label])
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.distribution = .fillProportionally
            stackView.spacing = cellSpacing
            return stackView
        }()
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        ///Add image/label stack to the cell
        // Insets for cell layout
        cell.contentView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        cell.contentView.addSubview(verticalStackView)
        cell.contentView.tag = 101
        
        // Apply insets of stack equal to insets of the contentview
        verticalStackView.leadingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        verticalStackView.topAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.topAnchor).isActive = true
        
        //Determine Cell-Color based on whether or not a feature is already active
        if (data.filter { $0 == label.text}).count == 1 {
            cell.contentView.backgroundColor = self.view.tintColor
        }
        
        //Disable gestures (needed to allow users to click on a cell)
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        
        //Round Edges
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
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
            if(data.count == 0) { // Limit One Selection
                //Add feature to array of selected features
                data.append(myLabels[index.row])
                //Change appearance of cell
                cell.contentView.backgroundColor = cell.tintColor
                // Auto Pass back information to remove necessity to click save button - Only use when single selection is active
                delegate?.passDataBack(currFeature: currFeature, data: data.count > 0 ? data[0] == "" ? [] : data : [])
                    presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            //Debugging Console
            print("Deselecting Feature: " + myLabels[index.row])
            //Remove feature from array of selected features
            data = data.filter{ $0 != myLabels[index.row]}
            if #available(iOS 13.0, *) {
                cell.contentView.backgroundColor = UIColor.systemBackground
            } else {
                cell.contentView.backgroundColor = .white
            }
         }
       }
      
    }
    
    @IBAction func submitFeature(_ sender: Any) {
        delegate?.passDataBack(currFeature: currFeature, data: data)
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    self.navigationController?.popViewController(animated: true)
        
    }
    
}
