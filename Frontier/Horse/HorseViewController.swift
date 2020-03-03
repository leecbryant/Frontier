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
    @IBOutlet weak var ImageScroller: UIScrollView!
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
                
        for i in 0..<imageArray.count {
                   let imageView = UIImageView()
                   // imageView.image = imageArray[i]
                   imageView.kf.indicatorType = .activity
                   imageView.kf.setImage(with: URL(string: imageArray[i])) { result in
                           switch result {
                               case .success(let value):
                                    imageView.contentMode = .center;
                                    if (self.ImageScroller.bounds.size.width < value.image.size.width && self.ImageScroller.bounds.size.height < value.image.size.height) {
                                        imageView.contentMode = .scaleAspectFit;
                                    }
                               case .failure(let error):
                                   print(error)
                           }
                    }
            let xPos = self.view.bounds.width * CGFloat(i)
                   imageView.frame = CGRect(x: xPos, y: 0, width: self.ImageScroller.frame.width, height: self.ImageScroller.frame.height)
                    // imageView.contentMode = .scaleAspectFit
                   
                    self.ImageScroller.contentSize.width = self.ImageScroller.frame.width * CGFloat(i + 1)
                    self.ImageScroller.addSubview(imageView)
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
}