//
//  CustomTopCell.swift
//  Frontier
//
//  Created by Lee Bryant on 12/1/19.
//  Copyright © 2019 Lee Bryant. All rights reserved.
//

import Foundation
import UIKit

class CustomTopCell: UITableViewCell {
    var Message: String?
    var Image: UIImage?
    
    var MessageView: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = false
        // textView.textAlignment = NSTextAlignment.center
        return textView
    }()
    
    var ImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(ImageView)
        self.addSubview(MessageView)
        
        ImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        ImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        ImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        ImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        ImageView.bottomAnchor.constraint(equalTo: self.MessageView.topAnchor).isActive = true

        MessageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        MessageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        MessageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let Message = Message {
            MessageView.text = Message
        }
        
        if let Image = Image {
            ImageView.image = Image
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
