//
//  Favourites.swift
//  FlickrSearch
//
//  Created by Aravind Ashok kumar on 11/8/15.
//  Copyright (c) 2015 ISS. All rights reserved.
//

import Foundation
import CoreData

class Favourites: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var imageURL: String
    @NSManaged var comments: String

}
