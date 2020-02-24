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

struct GuideData {
    var Description: String?
    var Examples: [Example]
}

class GuideViewController: UIViewController {

    @IBOutlet weak var Description: UITextView!
    @IBOutlet weak var DescriptionHC: NSLayoutConstraint!
    var guideSelection = 0

    @IBOutlet weak var tableView: UITableView!
    
    var data = [GuideData]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // self.tableView.register(CustomTopCell.self, forCellReuseIdentifier: "GuideCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 80
        
        // Do any additional setup after loading the view.
        navigationItem.title = items[myIndex]

        data = [
            // Initialize Index 0 - Colors
            GuideData.init(Description: "A horse's color is defined as the color of the fur. Examples of colors are listed below.", Examples:
                [Example.init(Title: "Brown", Image: UIImage(named: "brown")),
                Example.init(Title: "White", Image: UIImage(named: "white"))
                ]
            ),
            // Initialize Index 1 - Markings
            GuideData.init(Description: "A horse's marking is defined as the marking that is on the front of their skull. Examples of markings are listed below.", Examples: [Example.init(Title: "Circle", Image: UIImage(named: "circle"))]),
            // Initialize Index 2 - Socks
            GuideData.init(Description: "A horse's sock type is defined as the color of their fur on the bottom of each of their legs. Examples of sock types are listed below.", Examples: [Example.init(Title: "Back Left White Sock", Image: UIImage(named: "backsock"))])
        ]
        
        Description.text = data[myIndex].Description
        DescriptionHC.constant = self.Description.contentSize.height
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
        return data[myIndex].Examples.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuideCell", for: indexPath)

        cell.textLabel?.text = data[myIndex].Examples[indexPath.row].Title

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
            vc?.data = data
            vc?.selectedIndex = guideSelection
            vc?.topIndex = myIndex
        }
    }
}
