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

var Bands = ["Horse Band 1", "Horse Band 2", "Horse Band 3", "Horse Band 4", "Horse Band 5", "Horse Band 6","Horse Band 7", "Horse Band 8", "Horse Band 9", "Horse Band 10", "Horse Band 11", "Horse Band 12", "Horse Band 13", "Horse Band 14", "Horse Band 15", "Horse Band 16", "Horse Band 17", "Horse Band 18", "Horse Band 19", "Horse Band 20"]
var filteredBands = [HorseData]()

var images = [UIImage(named: "black"), UIImage(named: "bay")]
class HorseViewController: UIViewController {
    // Labels
    @IBOutlet weak var tableView: UITableView!
    // Image Definitions
    
    @IBOutlet weak var BandLabel: UILabel!
    
    @IBOutlet weak var ImageScroller: UICollectionView!
    
    var data = [HorseData]()
    var imageArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterBands()
        navigationItem.title = data[selectedIndex].Name
        
        BandLabel.text = Bands[data[selectedIndex].Band] + " Members"
//        nameText.text = data[selectedIndex].Name
//        dartedText.text = data[selectedIndex].DartStatus
        
        imageArray = ["https://whims.wildhorsepreservation.org/UNR/2_0_59090036bdec6.jpg",
                      "https://whims.wildhorsepreservation.org/UNR/2_1_59090036d6816.jpg",
                      "https://whims.wildhorsepreservation.org/UNR/2_0_5914b6736bb29.jpg",
                      "https://whims.wildhorsepreservation.org/UNR/2_0_5d2bd072dad87.jpg",
                      "https://whims.wildhorsepreservation.org/UNR/2_0_5bc4cb1c501c0.jpg"
        ]
        
        if filteredBands.count > 0 {
            BandLabel.isHidden = false
        } else {
            BandLabel.isHidden = true
        }
        // Image Pager Setup
//        ImagePager.numberOfPages = imageArray.count
//        ImagePager.currentPage = 0
        
        ImageScroller.delegate = self
        ImageScroller.dataSource = self
        ImageScroller.prefetchDataSource = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
    }

    func filterBands() {
        filteredBands = data.filter({ horse -> Bool in
            return horse.Band == data[selectedIndex].Band && horse.Name != data[selectedIndex].Name
        })
        filteredBands.sort(by: {$0.Name < $1.Name})
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
//        print("Row Selected with id: \(filteredBands[indexPath.row].id)")
        selectedIndex = filteredBands[indexPath.row].id
//        self.viewDidLoad()
//        self.viewWillAppear(true)
//        tableView.reloadData()

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HorseViewController") as! HorseViewController
            vc.data = data
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// Horse Image scroller collection view setup
extension HorseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let urls = imageArray.compactMap { URL(string: $0) }
        ImagePrefetcher(urls: urls).start()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count;
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! HorseCollectionViewCell
        let imageView:UIImageView=UIImageView(frame: CGRect(x: 0, y: 0, width: super.view.frame.width, height: ImageScroller.frame.size.height))
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
    
//        let cache = ImageCache.default
        // Checks if image is already cached
//        if(!cache.isCached(forKey: imageArray[indexPath.row])) {
            DispatchQueue.main.async {
                for subview in cell.contentView.subviews {
                    subview.removeFromSuperview()
                }
                imageView.kf.indicatorType = .activity
                imageView.kf.setImage(with: URL(string: self.imageArray[indexPath.row]))
                imageView.tag = 102
                cell.addSubview(imageView)
                cell.contentView.tag = 102
//                cell.layer.masksToBounds = true
            }
//         } else {
//            cell.HorseImage.kf.indicatorType = .activity
//            cache.retrieveImage(forKey: imageArray[indexPath.row]) { result in
//                 switch result {
//                     case .success(let value):
//                         cell.HorseImage.image = value.image
//                     case .failure(let error):
//                         print(error)
//                 }
//             }
//         }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
         if (indexPath.row == imageArray.count) {
            // Bounce back to top
            self.ImageScroller?.scrollToItem(at: IndexPath(row: 0, section: 0),
            at: .top, animated: true)
         }
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
