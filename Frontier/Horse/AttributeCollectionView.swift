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
        return 20;
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
//            
//            
//            
//            switch(indexPath.row) {
//                case 0: // Color
//                    
//                case 1: // Other
//                
//                default:
//                
//            }
            
            
            
            
            
            
            
            
            
            
            let image = self.resizeImage(image: UIImage(named: ("AdvancedFeatureImages/HorseColor/" + data[selectedIndex].Color.lowercased()).filter{!" \n\t\r".contains($0)} )!, targetSize: CGSize(width: 80, height: 80))
            
            imageView.image = image.circleMask
            return imageView
        }()
        
        /// Add label below image
        let label: UILabel = {
            let label = UILabel()
            label.text = data[selectedIndex].Color
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
            stackView.spacing = 5
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

}
