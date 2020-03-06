//
//  AttributeCollectionView.swift
//  Frontier
//
//  Created by Lee Bryant on 3/6/20.
//  Copyright © 2020 Lee Bryant. All rights reserved.
//

import UIKit

extension HorseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch(SegmentedController.selectedSegmentIndex) {
            case 0:
                return 8
            case 1:
                return 3
            default:
                return 0
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "attributeCell", for: indexPath) as! HorseCollectionViewCell
         let imageView :UIImageView = {
                   let imageView = UIImageView(frame: CGRect(   x: 0,
                                                        y: 0,
                                                        width: (super.view.frame.width),
                                                        height: (collectionView.collectionViewLayout
                       .collectionViewContentSize.width)
                       ))
                   imageView.contentMode = UIView.ContentMode.scaleAspectFit
            
            
            var imagePath = "AdvancedFeatureImages/"
            
            switch(indexPath.row) {
                case 0: // Color
                    imagePath += "HorseColor/" + data[selectedIndex].Color.lowercased().filter{!" \n\t\r".contains($0)}
                case 1: // Mane
                    imagePath += "HorseMane/" + data[selectedIndex].Mane.lowercased().filter{!" \n\t\r".contains($0)}
                case 2: // Face
                    imagePath += "HorseFace/" + data[selectedIndex].Face.lowercased().filter{!" \n\t\r".contains($0)}
                case 3: // Whorl
                    imagePath += "HorseWhorl/" + data[selectedIndex].Whorl.lowercased().filter{!" \n\t\r".contains($0)}
                case 4: // Right Front Foot
                    imagePath += "HorseFeet/" + data[selectedIndex].rfFeet.lowercased().filter{!" \n\t\r".contains($0)}
                case 5: // Right Back Foot
                    imagePath += "HorseFeet/" + data[selectedIndex].rrFeet.lowercased().filter{!" \n\t\r".contains($0)}
                case 6: // Left Front Foot
                    imagePath += "HorseFeet/" + data[selectedIndex].lfFeet.lowercased().filter{!" \n\t\r".contains($0)}
                case 7: // Left Back Foot
                    imagePath += "HorseFeet/" + data[selectedIndex].lrFeet.lowercased().filter{!" \n\t\r".contains($0)}
                default:
                    imagePath += "missing"
            }
        
            var image = UIImage()
            if(SegmentedController.selectedSegmentIndex == 0) {
                image = self.resizeImage(image: UIImage(named: imagePath)!, targetSize: CGSize(width: 80, height: 80))
            } else if(SegmentedController.selectedSegmentIndex == 1) {
                image = self.resizeImage(image: UIImage(named: "missing")!, targetSize: CGSize(width: 80, height: 80))
            } else {
                image = self.resizeImage(image: UIImage(named: "missing")!, targetSize: CGSize(width: 80, height: 80))
            }

            
            imageView.image = image.circleMask
            return imageView
        }()
        
        /// Add label below image
        let label: UILabel = {
            let label = UILabel(frame: CGRect(x: 0,y: 0, width: 10, height: 200))
            if(SegmentedController.selectedSegmentIndex == 0) {
             switch(indexPath.row) {
                    case 0: // Color
                        label.text = data[selectedIndex].Color
                    case 1: // Mane
                        label.text = data[selectedIndex].Mane
                    case 2: // Face
                        label.text = data[selectedIndex].Face
                    case 3: // Whorl
                        label.text = data[selectedIndex].Whorl
                    case 4: // Right Front Foot
                        label.text = "Right Front: " + data[selectedIndex].rfFeet
                    case 5: // Right Back Foot
                        label.text = "Right Back: " + data[selectedIndex].rrFeet
                    case 6: // Left Front Foot
                        label.text = "Left Front: " + data[selectedIndex].lfFeet
                    case 7: // Left Back Foot
                        label.text = "Left Back: " + data[selectedIndex].lrFeet
                    default:
                        label.text = "MISSING"
                }
            } else if(SegmentedController.selectedSegmentIndex == 1) {
                label.text = filteredBands[indexPath.row].Name
            } else {
                label.text = "Missing"
            }
            label.numberOfLines = 2
            label.minimumScaleFactor = 0.8
            label.sizeToFit()
            label.adjustsFontSizeToFitWidth = true
            label.contentMode = UIView.ContentMode.scaleAspectFit
            label.lineBreakMode = .byWordWrapping
            return label
        }()
        
        let verticalStackView: UIStackView = {
           let stackView = UIStackView(arrangedSubviews: [imageView, label])
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.distribution = .fillProportionally
            stackView.spacing = 5
            stackView.contentMode = .scaleAspectFit
            return stackView
        }()
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        ///Add image/label stack to the cell
        // Insets for cell layout
        cell.contentView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        cell.contentView.addSubview(verticalStackView)
        cell.contentView.tag = 102
        
        // Apply insets of stack equal to insets of the contentview
        verticalStackView.leadingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        verticalStackView.topAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.topAnchor).isActive = true
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 4

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }
    
    func defineCellSize() {
        let screenSize = AttributeCollectionView.bounds
        let screenWidth = screenSize.width
        let cellSize = ((screenWidth-20)/cellsPerRow)-(cellSpacing)
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = 2*cellSpacing
        AttributeCollectionView.collectionViewLayout = layout
    }
    
    func setCVConstraints() {
        AttributeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        AttributeCollectionView.addConstraint(NSLayoutConstraint(item: AttributeCollectionView as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: AttributeCollectionView.superview!.bounds.height))
        AttributeCollectionView.addConstraint(NSLayoutConstraint(item: AttributeCollectionView as Any, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: AttributeCollectionView.superview!.bounds.width))
        AttributeCollectionView.frame = CGRect(x: 10 , y: 10, width: AttributeCollectionView.superview!.bounds.width, height: self.view.frame.height)

    }

}
