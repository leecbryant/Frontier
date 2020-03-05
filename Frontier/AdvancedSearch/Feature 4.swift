//
//  Feature.swift
//  AdvancedSearch
//
//  Created by Frontier Companion on 1/9/20.
//  Copyright © 2020 Frontier Companion. All rights reserved.
//
import UIKit
import Foundation

class Feature {
    var image: UIImage
    var title: String
    var selection: String
    
    init(image:UIImage, title:String, selection: String) {
        self.image = image
        self.title = title
        self.selection = selection
    }
}
