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
        
        for subview : AnyObject in subviews{
            if subview.tag == 101 {
            subview.removeFromSuperview()
            }
        }
        return
    }
}
