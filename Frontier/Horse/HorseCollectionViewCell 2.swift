//
//  HorseCollectionViewCell.swift
//  Frontier
//
//  Created by Lee Bryant on 3/3/20.
//  Copyright © 2020 Lee Bryant. All rights reserved.
//

import UIKit

class HorseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var HorseImage: UIImageView!
    override func prepareForReuse() {
        super.prepareForReuse()

        let subviews = self.subviews
        if subviews.count == 0 {
            return
        }

        for subview : AnyObject in subviews {
            if subview.tag == 102 {
                for subsubviews: AnyObject in subview.subviews
                {
                    subsubviews.removeFromSuperview()
                }
            }
        }
        return
    }
}
