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
    
    @IBOutlet weak var ImagePager: UIPageControl!
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
        ImagePager.numberOfPages = imageArray.count
        ImagePager.currentPage = 0
        
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
        
           guard let url = URL(string: self.getImageUrlFor(pos: indexPath.row)) else { return cell }
           
           let data = try? Data(contentsOf: url)
           
           if let data = data, let image = UIImage(data: data) {
               cell.set(image: image)
           }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
         if (indexPath.row == imageArray.count) {
            // Bounce back to top
            self.ImageScroller?.scrollToItem(at: IndexPath(row: 0, section: 0),
            at: .top, animated: true)
         }
//        ImagePager.currentPage = indexPath.row
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let x = scrollView.contentOffset.x
            let w = scrollView.bounds.size.width
            let currentPage = Int(ceil(x/w))
        ImagePager.currentPage = currentPage
    }
}
// Image Download Code
// Found at https://codingwarrior.com/2018/02/05/ios-display-images-in-uicollectionview/
protocol ImageTaskDownloadedDelegate {
    func imageDownloaded(position: Int)
}

class ImageTask {
    
    let position: Int
    let url: URL
    let session: URLSession
    let delegate: ImageTaskDownloadedDelegate
    
    var image: UIImage?
    
    private var task: URLSessionDownloadTask?
    private var resumeData: Data?
    
    private var isDownloading = false
    private var isFinishedDownloading = false
 
    init(position: Int, url: URL, session: URLSession, delegate: ImageTaskDownloadedDelegate) {
        self.position = position
        self.url = url
        self.session = session
        self.delegate = delegate
    }
    
    func resume() {
        if !isDownloading && !isFinishedDownloading {
            isDownloading = true
            
            // TODO: Add download code
        }
    }
    
    func pause() {
        if isDownloading && !isFinishedDownloading {
            // TODO: Add pause code
            
            self.isDownloading = false
        }
    }
    
    private func downloadTaskCompletionHandler(url: URL?, response: URLResponse?, error: Error?) {
        self.isFinishedDownloading = true
    }
}
