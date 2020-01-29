//
//  CollectionViewCell.swift
//  AdvancedSearch
//
//  Created by Frontier Companion on 1/9/20.
//  Copyright © 2020 Frontier Companion. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var myView: UIView!
    
    override var bounds: CGRect {
        didSet {
          contentView.frame = bounds
        }
    }
    
    func setBounds(bounds:CGRect) {
        super.bounds = bounds
        self.contentView.frame = bounds;
    }
    
    
}
