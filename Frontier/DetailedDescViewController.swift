//
//  GuideViewController.swift
//  Frontier
//
//  Created by Lee Bryant on 11/25/19.
//  Copyright © 2019 Lee Bryant. All rights reserved.
//

import UIKit



class DetailedViewController: UIViewController {

    @IBOutlet weak var bgImage: UIImageView!
    var data = [GuideData]()
    var selectedIndex = 0
    var topIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Info"
        
        bgImage.image =  self.data[topIndex].Examples[selectedIndex].Image
    }
    
}
