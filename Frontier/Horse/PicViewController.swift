//
//  PicViewController.swift
//  Frontier
//
//  Created by Lee Bryant on 3/5/20.
//  Copyright © 2020 Lee Bryant. All rights reserved.
//

import UIKit

class PicViewController: UIViewController {
    
    @IBOutlet weak var ImageView: UIImageView!
    var image = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Image Preview"
        ImageView.image = image
    }
}
