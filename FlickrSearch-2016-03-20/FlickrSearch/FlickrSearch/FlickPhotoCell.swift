//
//  FlickPhotoCell.swift
//  FlickrSearch
//
//  Created by Aravind Ashok kumar on 10/8/15.
//  Copyright (c) 2015 ISS. All rights reserved.
//

import UIKit

class FlickPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
  //  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selected = false
    }
    
    override var selected : Bool {
        didSet {
        self.backgroundColor = selected ? UIColor.blueColor() : UIColor.blackColor()
        }
    }
    
}
