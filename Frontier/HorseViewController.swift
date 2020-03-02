//
//  HorseViewController.swift
//  Frontier
//
//  Created by Lee Bryant on 11/25/19.
//  Copyright © 2019 Lee Bryant. All rights reserved.
//

import UIKit
import class Kingfisher.KingfisherManager

var Bands = ["Horse Band 1", "Horse Band 2", "Horse Band 3", "Horse Band 4", "Horse Band 5", "Horse Band 6","Horse Band 7", "Horse Band 8", "Horse Band 9", "Horse Band 10", "Horse Band 11", "Horse Band 12", "Horse Band 13", "Horse Band 14", "Horse Band 15", "Horse Band 16", "Horse Band 17", "Horse Band 18", "Horse Band 19", "Horse Band 20"]
var filteredBands = [HorseData]()

var images = [UIImage(named: "black"), UIImage(named: "bay")]
class HorseViewController: UIViewController {
    
    // Labels
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var bandText: UILabel!
    @IBOutlet weak var dartedText: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bandMembers: UILabel!
    // Image Definitions
    @IBOutlet weak var ImageScroller: UICollectionView!
    @IBOutlet weak var ImagePager: UIPageControl!
    
    
    var data = [HorseData]()
    var imageArray = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        filterBands()
        navigationItem.title = data[selectedIndex].Name
        
        nameText.text = data[selectedIndex].Name
        bandText.text = Bands[data[selectedIndex].Band]
        dartedText.text = data[selectedIndex].DartStatus
        imageArray = ["https://whims.wildhorsepreservation.org/UNR/2_0_59090036bdec6.jpg",
                      "https://whims.wildhorsepreservation.org/UNR/2_1_59090036d6816.jpg",
                      "https://whims.wildhorsepreservation.org/UNR/2_0_5914b6736bb29.jpg",
                      "https://whims.wildhorsepreservation.org/UNR/2_0_5d2bd072dad87.jpg",
                      "https://whims.wildhorsepreservation.org/UNR/2_0_5bc4cb1c501c0.jpg"
        ]
        
        if filteredBands.count > 0 {
            bandMembers.isHidden = false
        } else {
            bandMembers.isHidden = true
        }
        
        // Image Pager Setup
        ImagePager.numberOfPages = imageArray.count
        ImagePager.currentPage = 0
    }
    
    func filterBands() {
        filteredBands = data.filter({ horse -> Bool in
            return horse.Band == data[selectedIndex].Band && horse.Name != data[selectedIndex].Name
        })
    }
}

extension HorseViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredBands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bandCell", for: indexPath)
        cell.textLabel?.text = filteredBands[indexPath.row].Name
        cell.detailTextLabel?.text = filteredBands[indexPath.row].Location
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row Selected with id: \(filteredBands[indexPath.row].id)")
        selectedIndex = filteredBands[indexPath.row].id
        self.viewDidLoad()
        self.viewWillAppear(true)
        filterBands()
        tableView.reloadData()
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let oldWidth = image.size.width
        let scaleFactor =  newWidth / oldWidth

        let newHeight = image.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor

        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        image.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    

}


// Horse Image scroller collection view setup
extension HorseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? HorseCollectionViewCell
            cell?.HorseImage.kf.indicatorType = .activity
            cell?.HorseImage.kf.setImage(with: URL(string: imageArray[indexPath.row]))
                { result in
                    switch result {
                    case .success(let value):
                        
                        cell?.HorseImage?.image = self.resizeImage(image: value.image, newWidth: self.ImageScroller.frame.size.width)
                    case .failure(let error):
                        print(error) // The error happens
                    }
                }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
         if (indexPath.row == imageArray.count - 1 ) {
            // Bounce back to top
            ImagePager.currentPage = 0;
            self.ImageScroller?.scrollToItem(at: IndexPath(row: 0, section: 0),
            at: .top, animated: true)
         }
        ImagePager.currentPage = indexPath.row
    }
}

// Horse Image scroller collection view setup
extension HorseViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = ImageScroller.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
