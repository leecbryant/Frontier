//
//  FeatureCell.swift
//  AdvancedSearch
//
//  Created by Frontier Companion on 1/9/20.
//  Copyright © 2020 Frontier Companion. All rights reserved.
//

import UIKit

class FeatureCell: UITableViewCell {

    @IBOutlet weak var featureImageView: UIImageView!
    @IBOutlet weak var featureTitleLabel: UILabel!
    @IBOutlet weak var featureSelectionLabel: UILabel!
    
    func setFeature(feature: Feature) {
        featureImageView.image = feature.image
        featureTitleLabel.text = feature.title
        featureSelectionLabel.text = feature.selection
        
    }
}
