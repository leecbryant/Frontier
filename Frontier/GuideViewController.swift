//
//  GuideViewController.swift
//  Frontier
//
//  Created by Lee Bryant on 11/25/19.
//  Copyright © 2019 Lee Bryant. All rights reserved.
//

import UIKit

struct Example {
    var Title: String?
    var Image: UIImage?
}
/*
struct GuideData {
    var Description: String?
    var Examples: [Example]
}*/

class GuideViewController: UIViewController{

    @IBOutlet weak var navBar: UINavigationItem!
    //@IBOutlet weak var Description: UITextView!
    
    
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    
    var guideSelection = 0

    //@IBOutlet weak var tableView: UITableView!
    
    var data = [String]()
    
    ///PASSED IN VARIABLES FROM PREVIOUS VIEW CONTROLLER
    var items = [String]()
    var selectedIndex = 0
    

    
    
     
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
        navigationItem.title = items[myIndex]

        Description.superview!.bounds = Description.superview!.frame.insetBy(dx: 10.0, dy: 10.0)
        
        if ((items[ selectedIndex ].lowercased() == "color"))
        {
            Description.text = "A horse's color is defined as the color of their fur, not including the mane or tail."
            data = ["Applaloosa", "Bay", "Bay Roan", "Black", "Blue Roan", "Brown","Buckskin", "Chestnut", "Cremello", "Gray", "Palomino", "Pinto", "Red Roan"]
        } else if ((items[ selectedIndex ].lowercased() == "mane"))
        {
            Description.text = "The horse's mane is the long fur on its head and on its rear, and can be a different color than the rest of the horse."
            data = ["Alternating", "Black", "Brown", "Flaxen", "Gray", "Multicolor", "Red", "Split", "White", "Body-Same", "Body-Lighter", "Body-Darker"]
        }  else if ((items[ selectedIndex ].lowercased() == "face"))
        {
            Description.text = "A horse's face markings can be used to identify them, usually being a different color than the rest of their skin."
            data = ["Blaze","Snip", "Star", "Stripe"]
            
        }
        else if ((items[ selectedIndex ].lowercased() == "whorl"))
        {
            Description.text = "A hair whorl is a patch of hair growing in the opposite direction of the rest of the hair."
            data = ["Example"]
        }
        else if ((items[ selectedIndex ].lowercased() == "sock types"))
        {
            Description.text = "A sock is a different color marking on the legs and hoof-areas of a horse."
            data = ["Coronet","Fetlock", "Heel", "Pastern", "Tall Socks"]
        }
        else if ((items[ selectedIndex ].lowercased() == "terminology"))
        {
            Description.text = "Click on one of the options below to learn more about the term."
            data = ["Band"]
        }
        
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.reloadData()
    }

}

extension GuideViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "GuideCell", for: indexPath)
//        cell.textLabel?.text = data[myIndex].Examples[indexPath.row].Title
//        // cell.Image = data[myIndex].Examples[indexPath.row].Image
//        cell.layoutSubviews()
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(data.count)
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("GENERATING CELLS")
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuideCell", for: indexPath)
        
        cell.textLabel?.text = data[indexPath.row]

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guideSelection = indexPath.row
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is DetailedViewController
        {
            let vc = segue.destination as? DetailedViewController
            vc?.item = items
            vc?.data = data
            vc?.selectedDataIndex = guideSelection
            vc?.selectedItemIndex = selectedIndex

        }
    }
}
