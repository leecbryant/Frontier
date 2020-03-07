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
                return filteredBands[0].data.count
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
                    imagePath += "HorseColor/" + HorseMarkingData.color.lowercased().filter{!" \n\t\r".contains($0)}
                case 1: // Mane
                    if(HorseMarkingData.Mane_Color != nil) {
                        imagePath += "HorseMane/" + HorseMarkingData.Mane_Color!.lowercased().filter{!" \n\t\r".contains($0)}
                    }
                    break
                case 2: // Face
                    if(HorseMarkingData.FaceString != nil) {
                        imagePath += "HorseFace/" + HorseMarkingData.FaceString!.lowercased().filter{!" \n\t\r".contains($0)}
                    }
                    break
                case 3: // Whorl
                    break
                case 4: // Right Front Foot
                    if(HorseMarkingData.RFMarking != nil) {
                        imagePath += "HorseFeet/" + HorseMarkingData.RFMarking!.lowercased().filter{!" \n\t\r".contains($0)}
                    }
                    break
                case 5: // Right Back Foot
                    if(HorseMarkingData.RHMarking != nil) {
                        imagePath += "HorseFeet/" + HorseMarkingData.RHMarking!.lowercased().filter{!" \n\t\r".contains($0)}
                    }
                    break
                case 6: // Left Front Foot
                    if(HorseMarkingData.LFMarking != nil) {
                        imagePath += "HorseFeet/" + HorseMarkingData.LFMarking!.lowercased().filter{!" \n\t\r".contains($0)}
                    }
                    break
                case 7: // Left Back Foot
                    if(HorseMarkingData.LHMarking != nil) {
                        imagePath += "HorseFeet/" + HorseMarkingData.LHMarking!.lowercased().filter{!" \n\t\r".contains($0)}
                    }
                    break
                default:
                    imagePath += "missing"
            }
        
            if(SegmentedController.selectedSegmentIndex == 0) {
                imageView.image = self.resizeImage(image: UIImage(named: imagePath) ?? UIImage(named: "missing")!, targetSize: CGSize(width: 100, height: 100))
            } else if(SegmentedController.selectedSegmentIndex == 1) {
                imageView.kf.indicatorType = .activity
                imageView.kf.setImage(with: URL(string: HorseImageData[0].data.filter({ (Photo) -> Bool in
                        return Photo.ID == filteredBands[0].data[indexPath.row].ID
                })[0].ImageFile.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil))) { result in
                    switch(result) {
                        case .success(let value):
                            imageView.image = imageView.image?.circleMask
                            imageView.image = self.resizeImage(image: value.image, targetSize: CGSize(width: 100, height: 100))
                            self.AttributeCollectionView.reloadItems(at: [indexPath])
                        case .failure(_): break
                    }
                }
            } else {
                imageView.image = self.resizeImage(image: UIImage(named: "missing")!, targetSize: CGSize(width: 100, height: 100))
            }

            
            imageView.image = imageView.image?.circleMask
            return imageView
        }()
        
        /// Add label below image
        let label: UILabel = {
            let label = UILabel(frame: CGRect(x: 0,y: 0, width: 10, height: 200))
            if(SegmentedController.selectedSegmentIndex == 0) {
             switch(indexPath.row) {
                    case 0: // Color
                        label.text = "Color: " + HorseMarkingData.color
                        returnabl[indexPath.row] = true
                    case 1: // Mane
                        if(HorseMarkingData.Mane_Color != nil) {
                            label.text = "Mane: " + HorseMarkingData.Mane_Color!
                            returnabl[indexPath.row] = true
                        } else {
                            returnabl[indexPath.row] = false
                        }
                        break
                    case 2: // Face
                        if(HorseMarkingData.FaceString != nil) {
                            label.text = "Face: " + HorseMarkingData.FaceString!
                            returnabl[indexPath.row] = true
                        } else {
                            returnabl[indexPath.row] = false
                        }
                        break
                    case 3: // Whorl
                        returnabl[indexPath.row] = false
                        break
                    case 4: // Right Front Foot
                        if(HorseMarkingData.RFMarking != nil) {
                            label.text = "Right Front: " + HorseMarkingData.RFMarking!
                            returnabl[indexPath.row] = true
                        } else {
                            returnabl[indexPath.row] = false
                        }
                        break
                    case 5: // Right Back Foot
                        if(HorseMarkingData.RHMarking != nil) {
                            label.text = "Right Rear: " + HorseMarkingData.RHMarking!
                            returnabl[indexPath.row] = true
                        } else {
                            returnabl[indexPath.row] = false
                        }
                        break
                    case 6: // Left Front Foot
                        if(HorseMarkingData.LFMarking != nil) {
                            label.text = "Left Front: " + HorseMarkingData.LFMarking!
                            returnabl[indexPath.row] = true
                        } else {
                            returnabl[indexPath.row] = false
                        }
                        break
                    case 7: // Left Back Foot
                        if(HorseMarkingData.LHMarking != nil) {
                            label.text = "Left Rear: " + HorseMarkingData.LHMarking!
                            returnabl[indexPath.row] = true
                        } else {
                            returnabl[indexPath.row] = false
                        }
                    default:
                        label.text = "MISSING"
                }
            } else if(SegmentedController.selectedSegmentIndex == 1) {
                label.text = filteredBands[0].data[indexPath.row].Name
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
        
    
        // Add tap gesture to band member cells
        if(SegmentedController.selectedSegmentIndex == 1) {
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        }
        
        return cell
        
    }
    
    // Function is ran whenever a user taps on a cell
    @objc func tap(_ sender: UITapGestureRecognizer) {
        if(SegmentedController.selectedSegmentIndex == 1) {
           let location = sender.location(in: AttributeCollectionView)
           let indexPath = AttributeCollectionView.indexPathForItem(at: location)
            selectedIndex = Int(filteredBands[0].data[indexPath!.row].ID)!
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "HorseViewController") as! HorseViewController
                vc.HorseData = BaseHorseData[0].data.filter({ (horse) -> Bool in
                    return Int(horse.ID)! == selectedIndex
                })[0]
              vc.BaseHorseData = BaseHorseData
              vc.filteredBands = BaseHorseData
              vc.HorseImageData = HorseImageData
              vc.imageArray = HorseImageData[0].data.filter({ (Photo) -> Bool in
                return Int(Photo.ID)! == selectedIndex
              })
              vc.HorseLedger = HorseLedger
              vc.HorseDartData = HorseLedger[0].data.sorted(by: {$0.Date > $1.Date}).filter{ (Horse) -> Bool in
                  return Int(Horse.HorseID)! == selectedIndex
              }
              vc.HorseAttributes = HorseAttributes
              vc.HorseMarkingData = HorseAttributes[0].data.filter{ (Horse) -> Bool in
                    return Int(Horse.ID)! == selectedIndex
              }[0]
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
