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
    
    @IBOutlet weak var FirstImage: UIImageView!
    @IBOutlet weak var SecondImage: UIImageView!
    @IBOutlet weak var ThirdImage: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    
    var data = [HorseData]()
    var imageArray = [String]()
    var ExtraImages = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterBands()
        navigationItem.title = data[selectedIndex].Name
        
//        BandLabel.text = Bands[data[selectedIndex].Band] + " Members"
//        nameText.text = data[selectedIndex].Name
//        dartedText.text = data[selectedIndex].DartStatus
        NameLabel.text = data[selectedIndex].Name
        LocationLabel.text = data[selectedIndex].Location
        
        
        imageArray = ["https://whims.wildhorsepreservation.org/UNR/2_0_59090036bdec6.jpg",
                      "https://whims.wildhorsepreservation.org/UNR/2_1_59090036d6816.jpg",
                      "https://whims.wildhorsepreservation.org/UNR/2_0_5914b6736bb29.jpg",
                      "https://whims.wildhorsepreservation.org/UNR/2_0_5d2bd072dad87.jpg",
                      "https://whims.wildhorsepreservation.org/UNR/2_0_5bc4cb1c501c0.jpg"
        ]
        
//        if filteredBands.count > 0 {
//            BandLabel.isHidden = false
//        } else {
//            BandLabel.isHidden = true
//        }
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
                    ThirdImage.kf.indicatorType = .activity
                    ThirdImage.kf.setImage(with: URL(string: imageArray[i]))
                default:
                    ExtraImages = true;
            }
        }

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
