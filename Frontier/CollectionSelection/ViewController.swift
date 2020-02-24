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
                 "Multicolor","Red", "White", "Body: Same",
                 "Body: Lighter", "Body: Darker"]
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
    
    override func viewDidAppear(_ animated: Bool) {
        let cellSize = (collectionView.collectionViewLayout
            .collectionViewContentSize.width / cellsPerRow) - (cellSpacing)

        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        collectionView.collectionViewLayout = layout
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
            imageView.image = UIImage(named: myLabels[indexPath.item].lowercased().filter{!" \n\t\r".contains($0)})
            
            return imageView
        }()
        
        /// Add label below image
        let label: UILabel = {
            let label = UILabel()
            label.text = myLabels[indexPath.item]
            label.numberOfLines = 0
            label.minimumScaleFactor = 0.9
            label.font = label.font.withSize(self.view.frame.height * relativeFontConstant / cellsPerRow)
            return label
        }()
        
        let verticalStackView: UIStackView = {
           let stackView = UIStackView(arrangedSubviews: [imageView, label])
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.distribution = .fillProportionally
            stackView.spacing = cellSpacing
            stackView.tag = 101
            return stackView
        }()
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        print(cell.subviews.count)
        let viewWithTag =  cell.subviews[0].viewWithTag(101)
        
        
        if viewWithTag == nil{
            
            cell.addSubview(verticalStackView)
        } else {
            viewWithTag!.removeFromSuperview()
        }
        
        verticalStackView.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
        verticalStackView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        
        //cell.contentLabel.text = myLabels[indexPath.item]
        //cell.contentLabel.font = cell.contentLabel.font.withSize(self.view.frame.height * relativeFontConstant / cellsPerRow)
        
        //Determine Cell-Color based on whether or not a feature is active
        if (data.filter { $0 == label.text}).count == 1 {
            cell.myView.backgroundColor = self.view.tintColor
        }
        //Disable gestures (needed to allow users to click on a cell)
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        cell.myView.frame = cell.bounds
        cell.myView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        cell.layoutIfNeeded()
        
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
            cell.myView.backgroundColor = self.view.tintColor
        }
            //Code for De-Selecting a feature
        else{
            //Debugging Console
            print("Deselecting Feature: " + myLabels[index.row])
            //Remove feature from array of selected features
            data = data.filter{ $0 != myLabels[index.row]}
            if #available(iOS 13.0, *) {
                cell.myView.backgroundColor = UIColor.systemBackground
            } else {
                cell.myView.backgroundColor = .white
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
