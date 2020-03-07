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
import struct Kingfisher.BlendImageProcessor
var Bands = ["Horse Band 1", "Horse Band 2", "Horse Band 3", "Horse Band 4", "Horse Band 5", "Horse Band 6","Horse Band 7", "Horse Band 8", "Horse Band 9", "Horse Band 10", "Horse Band 11", "Horse Band 12", "Horse Band 13", "Horse Band 14", "Horse Band 15", "Horse Band 16", "Horse Band 17", "Horse Band 18", "Horse Band 19", "Horse Band 20"]

var images = [UIImage(named: "black"), UIImage(named: "bay")]
class HorseViewController: UIViewController {
    // Labels
    @IBOutlet weak var tableView: UITableView!
    // Image Definitions
    
    @IBOutlet weak var FirstImage: UIImageView!
    @IBOutlet weak var SecondImage: UIImageView!
    @IBOutlet weak var ThirdImage: UIButton!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var AttributeCollectionView: UICollectionView!
    @IBOutlet weak var SegmentedController: UISegmentedControl!
    
    
    // Base horse information
    var BaseHorseData = [BaseHorse]()
    var filteredBands = [BaseHorse]()
    var HorseData = NameBandHerd(ID: "0", Name: "", herd: "", bands: "")
    // Horse Picture Information
    var HorseImageData = [HorsePhotos]()
    var imageArray = [Photo]()
    // Horse Dart Information
    var HorseLedger = [HorseTreatments]()
    var HorseDartData = [Treatment]()
    
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
        navigationItem.title = HorseData.Name
        NameLabel.text = HorseData.Name
        if(HorseDartData.count > 0) {
            LocationLabel.text = "Recent Shot: "
            switch(HorseDartData[0].Action) {
                case "P":
                    LocationLabel.text! += "Primer"
                case "B":
                    LocationLabel.text! += "Booster"
                default:
                    break
            }
        } else {
            LocationLabel.text = "Not Darted"
        }
        filterBands()
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        SegmentedController.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        for i in 0..<imageArray.count {
            print(imageArray[i].ImageFile)
            switch(i) {
                case 0:
                    FirstImage.kf.indicatorType = .activity
                    FirstImage.kf.setImage(with: URL(string: imageArray[i].ImageFile.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)))
                case 1:
                    SecondImage.kf.indicatorType = .activity
                    SecondImage.kf.setImage(with: URL(string: imageArray[i].ImageFile.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)))
                case 2:
//                    let blurProcessor = BlurImageProcessor(blurRadius: 75)
                    let blendProcessor = BlendImageProcessor(blendMode: .darken, alpha: 0.7, backgroundColor: .darkGray)
                    if(imageArray.count > 3) {
                        ThirdImage.kf.setBackgroundImage(with: URL(string: imageArray[i].ImageFile.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)), for: .normal, options: [.processor(blendProcessor)])
                    } else {
                        ThirdImage.kf.setBackgroundImage(with: URL(string: imageArray[i].ImageFile), for: .normal)
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
        } else if(imageArray.count < 3) {
            ThirdImage.isHidden = true
        } else {
            ThirdImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moreImages)))
        }
        ThirdImage.tag = 3
        let image = UIImage(named: "more-menu")?.withRenderingMode(.alwaysTemplate)
        ThirdImage.setImage(image, for: .normal)
        ThirdImage.tintColor = UIColor.white
    }

    @IBAction func DartPress(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "dart") as! DartTableViewController
        vc.HorseDartData = HorseDartData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func imageTapped(_ recognizer: UITapGestureRecognizer, index: Int) {
        
        let otherViewController = self.storyboard?.instantiateViewController(withIdentifier: "preview") as? PicViewController
        switch(recognizer.view!.tag) {
            case 1:
                otherViewController?.image = FirstImage.image!
            case 2:
                otherViewController?.image = SecondImage.image!
            case 3:
                otherViewController?.image = ThirdImage.currentBackgroundImage!
            default:
                print("Out of range")
        }
        
        show(otherViewController!, sender: self)
    }
    
    @objc private func moreImages(_ recognizer: UITapGestureRecognizer) {
        print("image tapped more")
    }
    
    func filterBands() {
        filteredBands[0].data = BaseHorseData[0].data.filter({ horse -> Bool in
            return horse.bands == HorseData.bands && horse.Name != HorseData.Name
        })
        filteredBands[0].data.sort(by: {$0.Name < $1.Name})
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
