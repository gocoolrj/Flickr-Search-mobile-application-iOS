//
//  OpenIn.swift
//  FlickrSearch
//
//  Created by Aravind Ashok kumar on 11/8/15.
//  Copyright (c) 2015 ISS. All rights reserved.
//

import Foundation
import UIKit
let UIActivityTypeFavs = "Add to Favourites"

class OpenIn: UIActivity {
    var docController: UIDocumentInteractionController!
    weak var barButton: UIBarButtonItem!
    
    // it's necessary to know which button the UIActivityViewController originated from
    init(barButton barB: UIBarButtonItem) {
        self.barButton = barB
    }
    // this provides a way of excluding the activity if we wish
    override func activityType() -> String? {
        return UIActivityTypeFavs
    }
    // provides title within popover
    override func activityTitle() -> String? {
        // your activity title here
        return "Add to Favourites"
    }
    // in real use you would provide image here at required size (see class reference)
    override func activityImage() -> UIImage? {
        // return your icon image here, for simplicity I've used nil
        return nil
    }
    // specify whether Action or Share (default is Action)
    override class func activityCategory() -> UIActivityCategory {
        // ,Share places the option on the top row
        return .Action
    }
    // confirm the action can be performed
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        for a in activityItems {
            if a is NSURL  {
                return true
            }
        }
        return false
    }
    // prepare for the activity
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        for a in activityItems {
            if let url = a as? NSURL  {
                docController = UIDocumentInteractionController(URL: url)
            }
        }
    }
    // perform the activity
    override func performActivity() {
        docController.presentOpenInMenuFromBarButtonItem(barButton, animated: true)
    }
}