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
    
    let colors = ["Appaloosa", "Bay", "Bay Roan",
                  "Black", "Blue Roan", "Brown",
                  "Buckskin", "Chestnut", "Cremello",
                  "Gray", "Palomino", "Pinto","Red Roan"]
    let manes = ["Left", "Right", "Split", "Alternating",
                 "Flaxen", "Black", "Brown", "Gray",
                 "Multicolor","Red", "White", "Body - Same",
                 "Body - Lighter", "Body - Darker"]
    let faces = ["None", "Blaze", "Star", "Snip", "Strip"]
    let whorls = ["At Eye Level", "Above Eye Level", "Below Eye Level", "Double", "Neck" ]
    let allFeet = ["None", "Coronet", "Pastern", "Heel", "Fetlock", "Tall Socks", "Stockings", "Ermine"]
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    let cellSpacing: CGFloat = 5
    let cellsPerRow: CGFloat = 2

    
    
    let colorImages: [UIImage] = [
    
        UIImage(named: "appaloosa")!,
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
    
    func defineCellSize()
    {
       
        //let cellSize = ((submitBtn.frame.width / cellsPerRow) - (cellSpacing))
        print (submitBtn.frame.width)
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
    
    func setCVConstraints()
    {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.addConstraint(NSLayoutConstraint(item: collectionView as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: collectionView.superview!.bounds.height))
        collectionView.addConstraint(NSLayoutConstraint(item: collectionView as Any, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: submitBtn.bounds.width))
        collectionView.frame = CGRect(x: 10 , y: 10, width: submitBtn.bounds.width, height: self.view.frame.height)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Set overall collectionview constraints
        setCVConstraints()
        /// Set the size of each cell relative ot screen size
        defineCellSize()
        
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
//        submitBtn.titleLabel?.font = submitBtn.titleLabel?.font.withSize(self.view.frame.height * relativeFontConstant)
        
        
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
            print(currFeature)
            if (currFeature == "color") {
                imageDirectory = "HorseColor/"
            } else if (currFeature == "mane") {
                imageDirectory = "HorseMane/"
            } else if (currFeature == "face") {
                
            } else if (currFeature == "whorl") {
                
            } else if (currFeature == "rfFeet") {
                
            } else if (currFeature == "rrFeet") {
                
            } else if (currFeature == "lfFeet") {
                
            } else if (currFeature == "lrFeet") {
                
            }
            
            let individualImage = myLabels[indexPath.item].lowercased().filter{!" \n\t\r".contains($0)}
            imageView.image = UIImage(named: (imageDirectory + individualImage))
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        /// Add label below image
        let label: UILabel = {
            let label = UILabel()
            label.text = myLabels[indexPath.item]
            label.numberOfLines = 0
            label.minimumScaleFactor = 0.8
            label.sizeToFit()
            //label.font = label.font.withSize(self.view.frame.height * relativeFontConstant / cellsPerRow)
            label.adjustsFontSizeToFitWidth = true
            label.contentMode = UIView.ContentMode.scaleAspectFit
            return label
        }()
        
        let verticalStackView: UIStackView = {
           let stackView = UIStackView(arrangedSubviews: [imageView, label])
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.distribution = .fillProportionally
            stackView.spacing = cellSpacing
            stackView.contentMode = .scaleAspectFit
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
        
        print(cell.bounds.width)
        
        print(cell.bounds.height)
        
        return cell
    }
    
    
    
    // Function is ran whenever a user taps on a cell
    @objc func tap(_ sender: UITapGestureRecognizer) {

       let location = sender.location(in: self.collectionView)
       let indexPath = self.collectionView.indexPathForItem(at: location)

        print(submitBtn.bounds.width)
        print(collectionView.bounds.width)
        print(submitBtn.superview!.bounds.width)
        
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
            cell.contentView.backgroundColor = cell.tintColor
        }
            //Code for De-Selecting a feature
        else{
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
    
    //Dynamically Size each cell relative to screen size
    /*func collectionView( _ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
      /*/calculate available screen size
      let paddingSpace = sectionInsets.left  * (itemsPerRow + 1)
      let availableWidth = view.frame.width - paddingSpace - 10
      let widthPerItem = availableWidth / itemsPerRow
        //Assign Cell a width/height*/
        //return cCGSizeMake(collectionView.frame.width/2, CUSTOM_HEIGHT);
        
        //let customSize = collectionView.frame.width/3
        //return CGSize(width: customSize, height: customSize)
    //}*/
    
    

    
    /*Dynamically Size each cell relative to screen size
    private func collectionView( _ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection indexPath: IndexPath) -> CGSize {
        let customSize = collectionView.frame.width/3
        return CGSize(width: customSize, height: customSize)
    }*/
    
    @IBAction func submitFeature(_ sender: Any) {
        delegate?.passDataBack(currFeature: currFeature, data: data)
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}
