//
//  HorseViewController.swift
//  Frontier
//
//  Created by Lee Bryant on 11/25/19.
//  Copyright © 2019 Lee Bryant. All rights reserved.
//

import UIKit
import class Kingfisher.KingfisherManager
import class Kingfisher.ImageCache
import class Kingfisher.ImagePrefetcher
import struct Kingfisher.BlurImageProcessor
import struct Kingfisher.TintImageProcessor

var Bands = ["Horse Band 1", "Horse Band 2", "Horse Band 3", "Horse Band 4", "Horse Band 5", "Horse Band 6","Horse Band 7", "Horse Band 8", "Horse Band 9", "Horse Band 10", "Horse Band 11", "Horse Band 12", "Horse Band 13", "Horse Band 14", "Horse Band 15", "Horse Band 16", "Horse Band 17", "Horse Band 18", "Horse Band 19", "Horse Band 20"]
var filteredBands = [HorseData]()

var images = [UIImage(named: "black"), UIImage(named: "bay")]
class HorseViewController: UIViewController {
    // Labels
    @IBOutlet weak var tableView: UITableView!
    // Image Definitions
    
    @IBOutlet weak var FirstImage: UIImageView!
    @IBOutlet weak var SecondImage: UIImageView!
    @IBOutlet weak var ThirdImage: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var AttributeCollectionView: UICollectionView!
    @IBOutlet weak var SegmentedController: UISegmentedControl!
    
    

    var data = [HorseData]()
    var imageArray = [String]()
    var firstImage = false
    
    // Collection View Definitions
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    let cellSpacing: CGFloat = 2
    let cellsPerRow: CGFloat = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Set overall collectionview constraints
        setCVConstraints()
        /// Set the size of each cell relative ot screen size
        defineCellSize()
                
        filterBands()
        navigationItem.title = data[selectedIndex].Name
        
        NameLabel.text = data[selectedIndex].Name
        LocationLabel.text = data[selectedIndex].Location
        
        
        imageArray = ["https://whims.wildhorsepreservation.org/UNR/2_0_59090036bdec6.jpg",
                      "https://whims.wildhorsepreservation.org/UNR/2_1_59090036d6816.jpg",
                      "https://whims.wildhorsepreservation.org/UNR/2_0_5914b6736bb29.jpg",
                      "https://whims.wildhorsepreservation.org/UNR/2_0_5d2bd072dad87.jpg",
                      "https://whims.wildhorsepreservation.org/UNR/2_0_5bc4cb1c501c0.jpg"
        ]
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        SegmentedController.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        for i in 0..<imageArray.count {
            switch(i) {
                case 0:
                    //FirstImage.superview!.frame = CGRect(x:20, y: 20, width: FirstImage.superview!.frame.width, height: self.view.frame.width)
                    FirstImage.superview!.backgroundColor = .yellow
                    FirstImage.kf.indicatorType = .activity
                    FirstImage.kf.setImage(with: URL(string: imageArray[i]))
                case 1:
                    SecondImage.kf.indicatorType = .activity
                    SecondImage.kf.setImage(with: URL(string: imageArray[i]))
                case 2:
                    let blurProcessor = BlurImageProcessor(blurRadius: 75)
                    FirstImage.kf.indicatorType = .activity
                    if(imageArray.count > 3) {
                        ThirdImage.kf.setImage(with: URL(string: imageArray[i]), options: [.processor(blurProcessor)])
                    } else {
                        ThirdImage.kf.setImage(with: URL(string: imageArray[i]))
                    }
                default:
                    print("Extra")
            }
        }
        
        // Make Images Clickable
        FirstImage.isUserInteractionEnabled = true
        FirstImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        FirstImage.tag = 1
        SecondImage.isUserInteractionEnabled = true
        SecondImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        SecondImage.tag = 2
        ThirdImage.isUserInteractionEnabled = true
        if(imageArray.count == 3) {
            ThirdImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        } else {
            ThirdImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moreImages)))
        }
        ThirdImage.tag = 3
    }

    @objc private func imageTapped(_ recognizer: UITapGestureRecognizer, index: Int) {
        
        let otherViewController = self.storyboard?.instantiateViewController(withIdentifier: "preview") as? PicViewController
        switch(recognizer.view!.tag) {
            case 1:
                otherViewController?.image = FirstImage.image!
            case 2:
                otherViewController?.image = SecondImage.image!
            case 3:
                otherViewController?.image = ThirdImage.image!
            default:
                print("Out of range")
        }
        
        show(otherViewController!, sender: self)
    }
    
    @objc private func moreImages(_ recognizer: UITapGestureRecognizer) {
        print("image tapped more")
    }
    
    func filterBands() {
        filteredBands = data.filter({ horse -> Bool in
            return horse.Band == data[selectedIndex].Band && horse.Name != data[selectedIndex].Name
        })
        filteredBands.sort(by: {$0.Name < $1.Name})
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    
    @IBAction func indexChanged(_ sender: Any) {
        AttributeCollectionView.reloadData()
    }

    
}

extension UIImage {
    var circleMask: UIImage {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    
    func overlayed(with overlay: UIImage) -> UIImage? {
        defer {
            UIGraphicsEndImageContext()
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        overlay.draw(in: CGRect(origin: CGPoint.zero, size: size))
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            return image
        }
        return nil
    }
}
