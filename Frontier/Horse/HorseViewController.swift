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

protocol PassEditToSearch {
    func editPassBack(response: Bool)
}

class HorseViewController: UIViewController, PassEditToHorse {
    
    
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
    
    @IBOutlet weak var DartButton: UIButton!
    var activityView: UIActivityIndicatorView?

    // Base horse information
    var BaseHorseData: BaseHorse = BaseHorse(data: [NameBandHerd]())
    var filteredBands: BaseHorse = BaseHorse(data: [NameBandHerd]())
    var HorseData = NameBandHerd(ID: 0, Name: "", herd: "", bands: "", Status: "")
    // Horse Picture Information
    var HorseImageData: HorsePhotos = HorsePhotos(data: [Photo]())
    var imageArray = [Photo]()
    // Horse Dart Information
    var HorseLedger:HorseTreatments = HorseTreatments(data: [Treatment]())
    var HorseDartData = [Treatment]()
    // Horse Attribute Information
    var HorseAttributes: HorseMarkings = HorseMarkings(data: [Marking]())
    var HorseMarkingData = Marking(HorseID: 0, color: "", Position: nil, Mane_Color: nil, LFMarking: nil, RFMarking: nil, LHMarking: nil, RHMarking: nil, FaceString: nil)
    // Collection View Definitions
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    let cellSpacing: CGFloat = 2
    let cellsPerRow: CGFloat = 2
    var returnableIndex: [Int] = [0, 1, 2, 3, 4, 5, 6, 7]
    var delegate: PassEditToSearch?
    var Refresh = false
    override func viewDidLoad() {
        
        super.viewDidLoad()
        /// Set overall collectionview constraints
        setCVConstraints()
        /// Set the size of each cell relative ot screen size
        defineCellSize()
        navigationItem.title = HorseData.Name
        NameLabel.text = HorseData.Name
//        if(HorseDartData.count > 0) {
            LocationLabel.text = "Status: "
//            switch(HorseDartData[0].Action) {
            switch(HorseData.Status) {
                case "S":
                    LocationLabel.text! += "Seen with Band"
                case "M":
                    LocationLabel.text! += "Missing from Band"
                default:
                    break
            }
//        } else {
//            LocationLabel.text = "Not Darted"
//        }
        filterBands()
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        SegmentedController.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        for i in 0..<imageArray.count {
            switch(i) {
                case 0:
                    FirstImage.kf.indicatorType = .activity
                    FirstImage.kf.setImage(with: URL(string: imageArray[i].ImageFile.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)))
                case 1:
                    SecondImage.kf.indicatorType = .activity
                    SecondImage.kf.setImage(with: URL(string: imageArray[i].ImageFile.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)))
                case 2:
//                    let blurProcessor = BlurImageProcessor(blurRadius: 75)
//                    let blendProcessor = BlendImageProcessor(blendMode: .darken, alpha: 0.7, backgroundColor: .darkGray)
                    if(imageArray.count > 3) {
//                        ThirdImage.kf.setBackgroundImage(with: URL(string: imageArray[i].ImageFile.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)), for: .normal, options: [.processor(blendProcessor)])
                        ThirdImage.kf.setBackgroundImage(with: URL(string: imageArray[i].ImageFile.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)), for: .normal)
                    } else {
                        ThirdImage.kf.setBackgroundImage(with: URL(string: imageArray[i].ImageFile), for: .normal)
                    }
                default: break
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
//        let image = UIImage(named: "more-menu")?.withRenderingMode(.alwaysTemplate)
//        ThirdImage.setImage(image, for: .normal)
        ThirdImage.tintColor = UIColor.white
        
        // Dart Button Setup
        let dartimage = UIImage(named: "needle")?.withRenderingMode(.alwaysTemplate)
        DartButton.setImage(dartimage, for: .normal)
        DartButton.tintColor = UIColor.white
    }

    @IBAction func DartPress(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "dart") as! DartTableViewController
        vc.HorseDartData = HorseDartData
        vc.HorseID = HorseData.ID
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
    
    func filterBands() {
        filteredBands.data = BaseHorseData.data.filter({ horse -> Bool in
            return horse.bands == HorseData.bands && horse.Name != HorseData.Name
        })
        filteredBands.data.sort(by: {$0.Name < $1.Name})
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
        AttributeCollectionView.setContentOffset(CGPoint.zero, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "showEdit":
                let vc = segue.destination as! EditHorse
                vc.BaseHorseData = BaseHorseData
                vc.filteredBands = BaseHorseData
                vc.HorseData = HorseData
                vc.HorseLedger = HorseLedger
                vc.HorseDartData = HorseLedger.data.sorted(by: {$0.Date > $1.Date}).filter{ (Horse) -> Bool in
                    return Horse.HorseID! == selectedIndex
                }
                vc.HorseAttributes = HorseAttributes
                vc.HorseMarkingData = HorseMarkingData
                vc.delegate = self
            break
            default: break
            // Unreachable
        }
    }
    @IBAction func onEdit(_ sender: Any) {
         performSegue(withIdentifier: "showEdit", sender: self)
    }
    
    func editPassBack(response: Bool, Name: String, Band: String, Location: String, Status: Bool) {
        if response {
            // loadData()
            HorseData.bands = Band
            HorseData.Name = Name
            HorseData.herd = Location
            //HorseMarkingData = Marking(
            NameLabel.text = Name
            LocationLabel.text = "Status: "
            //            switch(HorseDartData[0].Action) {
                        switch(Status) {
                            case true:
                                LocationLabel.text! += "Seen with Band"
                            case false:
                                LocationLabel.text! += "Missing from Band"
                        }
            navigationItem.title = Name
            filterBands()
            AttributeCollectionView.reloadData()
        }
    }
    
    func createAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        
        self.present(alert, animated: true, completion: nil)
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
