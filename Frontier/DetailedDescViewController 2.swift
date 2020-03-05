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
    
    ///BROAD GUIDE INFO (COLOR,MARKINGS,ETC)
    var item = [String]()
    
    ///SPECIFIC GUIDE INFO (BROWN,WHITE,ETC)
    var data = [String]()
    
    ///index used for selected data[]
    var selectedDataIndex = Int()
    ///index used for selected item
    var selectedItemIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = data[selectedDataIndex]
        
        let fileName = "guide/" + item[selectedItemIndex].lowercased() + "/" + data[selectedDataIndex].lowercased()
        
        bgImage.image =  UIImage(named: fileName)

    }
    
}
