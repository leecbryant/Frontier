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
var Bands = ["Horse Band 1", "Horse Band 2", "Horse Band 3", "Horse Band 4", "Horse Band 5", "Horse Band 6","Horse Band 7", "Horse Band 8", "Horse Band 9", "Horse Band 10", "Horse Band 11", "Horse Band 12", "Horse Band 13", "Horse Band 14", "Horse Band 15", "Horse Band 16", "Horse Band 17", "Horse Band 18", "Horse Band 19", "Horse Band 20"]
var filteredBands = [HorseData]()

var images = [UIImage(named: "black"), UIImage(named: "bay")]
class HorseViewController: UIViewController {
    // Labels
    @IBOutlet weak var tableView: UITableView!
    // Image Definitions
    @IBOutlet weak var ImageScroller: UIScrollView!
    
    @IBOutlet weak var BandLabel: UILabel!
    
    var data = [HorseData]()
    var imageArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ImageScroller.reloadInputViews()

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

        // Horse Images
        ImageScroller.delegate = self
        loadHorseImages()
        // Image Pager Setup
//        ImagePager.numberOfPages = imageArray.count
//        ImagePager.currentPage = 0
        
    }

    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       loadHorseImages()
    }

    override func viewDidLayoutSubviews() {
        self.ImageScroller.contentSize.width = self.ImageScroller.frame.width * CGFloat(imageArray.count + 1)
    }
    
    func loadHorseImages() {
        ImageScroller.subviews.forEach({ $0.removeFromSuperview() }) // this gets things done
        for i in 0..<imageArray.count {
            let imageView = UIImageView()
            imageView.setNeedsDisplay()
            ImageScroller.setNeedsDisplay()
            let cache = ImageCache.default
            // Checks if image is already cached
             if(!cache.isCached(forKey: imageArray[i])) {
                 imageView.kf.indicatorType = .activity
                 imageView.kf.setImage(with: URL(string: imageArray[i])) { result in
                     switch result {
                     case .success( _):
                            imageView.contentMode = .scaleAspectFit
                            let xPosition = self.ImageScroller.frame.width * CGFloat(i)
                            imageView.frame = CGRect(x: xPosition, y: 0, width: self.ImageScroller.frame.width, height: self.ImageScroller.frame.height)
                            self.ImageScroller.contentSize.width = self.ImageScroller.frame.width * CGFloat(i)
                            self.ImageScroller.addSubview(imageView)
                         case .failure(let error):
                             print(error) // The error happens
                     }
                 }
             } else {
                 cache.retrieveImage(forKey: imageArray[i]) { result in
                     switch result {
                         case .success(let value):
                             imageView.image = value.image
                             imageView.contentMode = .scaleAspectFit
                             let xPosition = self.ImageScroller.frame.width * CGFloat(i)
                             imageView.frame = CGRect(x: xPosition, y: 0, width: self.ImageScroller.frame.width, height: self.ImageScroller.frame.height)
                             self.ImageScroller.contentSize.width = self.ImageScroller.frame.width * CGFloat(i + 1)
                             self.ImageScroller.addSubview(imageView)
                         case .failure(let error):
                             print(error)
                     }
                 }
             }
        }
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
