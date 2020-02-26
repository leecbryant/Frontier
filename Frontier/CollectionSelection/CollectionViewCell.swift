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
    
    ///Needed to flush the subviews from cells during reload
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //Get # of subviews of cell
        let subviews = self.subviews
        //return if there are no subviews
        if subviews.count == 0{
            return
        }
        
        /// Remove duplication of cell data
        for subview : AnyObject in subviews{
            // If a contentView has already been rendered, remove the image and label
            //      so they can be reloaded (without duplication)
            if subview.tag == 101 {
                // Remove the subviews (stackview with image/label)
                for subsubviews: AnyObject in subview.subviews
                {
                    subsubviews.removeFromSuperview()
                }
            }
        }
        return
    }
}
