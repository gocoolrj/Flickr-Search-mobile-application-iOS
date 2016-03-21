//
//  ViewController.swift
//  FlickrSearch
//
//  Created by Aravind Ashok kumar on 8/8/15.
//  Copyright (c) 2015 ISS. All rights reserved.
//

import UIKit
import CoreData


class ViewController : UICollectionViewController,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    //for clearing searches
    @IBAction func clearAllSearches(sender: AnyObject) {
        searches = [FlickrSearchResults]()
        
         self.collectionView?.reloadData()
       
    }
    //for Sharing
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    
    private var selectedPhotos = [FlickrPhoto]()
    private let shareTextLabel = UILabel()
    var imageArray = [Favourites]()
    
    
    func updateSharedPhotoCount() {
        shareTextLabel.textColor = themeColor
        shareTextLabel.text = "\(selectedPhotos.count) photos selected"
        shareTextLabel.sizeToFit()
    }
    
    
    
    private let reuseIdentifier = "Cell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    private var searches = [FlickrSearchResults]()
    private let flickr = Flickr()
    
    func photoForIndexPath(indexPath: NSIndexPath) -> FlickrPhoto {
        return searches[indexPath.section].searchResults[indexPath.row]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       let favouritesBtn = UIBarButtonItem(image: UIImage(named: "Like-25.jpg"), style: UIBarButtonItemStyle.Plain, target: self, action: "favs:")
        
        
        navigationItem.setRightBarButtonItems([shareBtn,favouritesBtn], animated: true)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // 1
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        flickr.searchFlickrForTerm(textField.text) {
            results, error in
            
            //2
            activityIndicator.removeFromSuperview()
            if error != nil {
                println("Error searching : \(error)")
            }
            
            if results != nil {
                //3
                println("Found \(results!.searchResults.count) matching \(results!.searchTerm)")
                self.searches.insert(results!, atIndex: 0)
                
                //4
                self.collectionView?.reloadData()
            }
        }
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
    
    // For UI Collection View Delegate functions
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return searches.count
    }
    
    //2
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }
    
    //3
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            reuseIdentifier, forIndexPath: indexPath) as! FlickPhotoCell
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        let flickrPhoto = photoForIndexPath(indexPath)
        let btn = UIButton(frame: CGRectMake(50, 50, 150, 20));
        
        //1
        cell.title.text = flickrPhoto.title
        
        //2
        if indexPath != largePhotoIndexPath {
            cell.imageView.image = flickrPhoto.thumbnail
            return cell
        }
        
        //3
        if flickrPhoto.largeImage != nil {
            cell.imageView.image = flickrPhoto.largeImage
            cell.title.numberOfLines=3
            cell.title.sizeToFit()
          
            //cell.title.textAlignment = .Center
            return cell
        }
        
        //4
        cell.imageView.image = flickrPhoto.thumbnail
        
        cell.addSubview(activityIndicator)
        activityIndicator.frame = cell.bounds
        activityIndicator.startAnimating()
        
        //5
        flickrPhoto.loadLargeImage {
            loadedFlickrPhoto, error in
            
            //6
            activityIndicator.removeFromSuperview()
            
            //7
            if error != nil {
                return
            }
            
            if loadedFlickrPhoto.largeImage == nil {
                return
            }
            
            //8
            if indexPath == self.largePhotoIndexPath {
                if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? FlickPhotoCell {
                    cell.imageView.image = loadedFlickrPhoto.largeImage
                    //cell.title.textAlignment = .Center;
                    cell.title.numberOfLines=3
                    cell.title.sizeToFit()
                    
                    
                }
            }
        }
        return cell
    }
    
    //For UI Collecton View Delegate Flow Layout
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            let flickrPhoto =  photoForIndexPath(indexPath)
            //for large images
            
            if indexPath == largePhotoIndexPath {
                var size = collectionView.bounds.size
                size.height -= topLayoutGuide.length
                size.height -= (sectionInsets.top + sectionInsets.right)
                size.width -= (sectionInsets.left + sectionInsets.right)
                return flickrPhoto.sizeToFillWidthOfSize(size)
            }
            
            return CGSize(width: 150, height: 150)
    }
    
    //3
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    
    //UI Collection View DataSource
    
    override func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            //1
            switch kind {
                //2
            case UICollectionElementKindSectionHeader:
                //3
                let headerView =
                collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                    withReuseIdentifier: "FlickrPhotoHeaderView",
                    forIndexPath: indexPath)
                    as! FlickrPhotoHeaderView
                headerView.label.text = "Search : " + searches[indexPath.section].searchTerm
                return headerView
            default:
                //4
                assert(false, "Unexpected element kind")
            }
    }
    
    //Finding the tapped cell
    
    var largePhotoIndexPath : NSIndexPath? {
        didSet {
            //2
            var indexPaths = [NSIndexPath]()
            if largePhotoIndexPath != nil {
                indexPaths.append(largePhotoIndexPath!)
            }
            if oldValue != nil {
                indexPaths.append(oldValue!)
            }
            //3
            collectionView?.performBatchUpdates({
                self.collectionView?.reloadItemsAtIndexPaths(indexPaths)
                return
                }){
                    completed in
                    //4
                    if self.largePhotoIndexPath != nil {
                        self.collectionView?.scrollToItemAtIndexPath(
                            self.largePhotoIndexPath!,
                            atScrollPosition: .CenteredVertically,
                            animated: true)
                    }
            }
        }
    }
    
    //using this method to set the largeindexpath for selected item
    override func collectionView(collectionView: UICollectionView,
        shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
            
            if sharing {
                return true
            }
            if favourites {
                return true
            }
            
            if largePhotoIndexPath == indexPath {
                largePhotoIndexPath = nil
            }
            else {
                largePhotoIndexPath = indexPath
            }
            return false
    }
    
    //boolean to identify sharing
    
    var favourites : Bool = false {
        didSet {
            collectionView?.allowsMultipleSelection = favourites
            collectionView?.selectItemAtIndexPath(nil, animated: true, scrollPosition: .None)
            selectedPhotos.removeAll(keepCapacity: false)
            if favourites && largePhotoIndexPath != nil {
                largePhotoIndexPath = nil
            }
            
            
            let favouritesBtn = UIBarButtonItem(image: UIImage(named: "Like-25.jpg"), style: UIBarButtonItemStyle.Plain, target: self, action: "favs:")
            if favourites {
                updateSharedPhotoCount()
                let sharingDetailItem = UIBarButtonItem(customView: shareTextLabel)
                navigationItem.setRightBarButtonItems([shareBtn,favouritesBtn,sharingDetailItem], animated: true)
            }
            else {
                navigationItem.setRightBarButtonItems([shareBtn,favouritesBtn], animated: true)
            }
        }
    }
    
    
    var sharing : Bool = false {
        didSet {
            collectionView?.allowsMultipleSelection = sharing
            collectionView?.selectItemAtIndexPath(nil, animated: true, scrollPosition: .None)
            selectedPhotos.removeAll(keepCapacity: false)
            if sharing && largePhotoIndexPath != nil {
                largePhotoIndexPath = nil
            }
        
           let favouritesBtn = UIBarButtonItem(image: UIImage(named: "Like-25.jpg"), style: UIBarButtonItemStyle.Plain, target: self, action: "favs:")
            
            //UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Bookmarks, target: self, action: "favs:")
            
            if sharing {
                updateSharedPhotoCount()
                let sharingDetailItem = UIBarButtonItem(customView: shareTextLabel)
                navigationItem.setRightBarButtonItems([shareBtn,sharingDetailItem,favouritesBtn], animated: true)
            }
            else {
                navigationItem.setRightBarButtonItems([shareBtn,favouritesBtn], animated: true)
            }
        }
    }
    

    
    
    @IBAction func share(sender: AnyObject) {
        
        if searches.isEmpty {
            return
        }
        
        if !selectedPhotos.isEmpty {
            var imageArray = [UIImage]()
            for photo in self.selectedPhotos {
                imageArray.append(photo.thumbnail!);
            }
            
            let shareScreen = UIActivityViewController(activityItems: imageArray, applicationActivities: nil)
            let popover = UIPopoverController(contentViewController: shareScreen)
            popover.presentPopoverFromBarButtonItem(shareBtn,
                permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
        
        sharing = !sharing
    }
    
    @IBAction func favs(sender: UIBarButtonItem) {
        
        if searches.isEmpty {
            return
        }
        
        if !selectedPhotos.isEmpty {
            let entityDescription = NSEntityDescription.entityForName("Favourites", inManagedObjectContext:managedObjectContext!)
            
             var error : NSError?
            for photo in self.selectedPhotos {
                //imageArray.append(photo.thumbnail!);
                let newObject = Favourites(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
                
                let URL = photo.flickrImageURL(size: "b").absoluteString
                newObject.setValue( URL, forKey : "imageURL")
                newObject.setValue("" , forKey : "comments")
                newObject.setValue(photo.title, forKey: "title")
                managedObjectContext?.save(&error)
                imageArray.append(newObject)
                println(newObject.description)
            }
                
                if let err = error {
                  println( err.localizedFailureReason)
                    
                }
                else
                {
                   println("Saved")
                    
                    
                   performSegueWithIdentifier("showFavs", sender: self)
              
                    
                    
                }
            
        }
        
        self.favourites = !(self.favourites)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showFavs" {
           
            let nav = segue.destinationViewController as! UINavigationController
            let addEventViewController = nav.topViewController as! FavouritesList
                addEventViewController.photos = imageArray

            
        }
    }
    
    
    //selecting/deselecting items for sharing
    override func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {
            if sharing {
                let photo = photoForIndexPath(indexPath)
                selectedPhotos.append(photo)
                updateSharedPhotoCount()
            }
            if favourites {
                let photo = photoForIndexPath(indexPath)
                selectedPhotos.append(photo)
                
                updateSharedPhotoCount()
            }
            
            
    }
    
    override func collectionView(collectionView: UICollectionView,
        didDeselectItemAtIndexPath indexPath: NSIndexPath) {
            if sharing {
                if let foundIndex = find(selectedPhotos, photoForIndexPath(indexPath)) {
                    selectedPhotos.removeAtIndex(foundIndex)
                    
                    updateSharedPhotoCount()
                }
            }
            if favourites {
                if let foundIndex = find(selectedPhotos, photoForIndexPath(indexPath)) {
                    selectedPhotos.removeAtIndex(foundIndex)
                    imageArray.removeAtIndex(foundIndex)
                    updateSharedPhotoCount()
                }
            }
    }
    

}


