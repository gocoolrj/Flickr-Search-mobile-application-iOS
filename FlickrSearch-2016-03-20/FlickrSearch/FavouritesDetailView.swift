//
//  FavouritesDetailView.swift
//  FlickrSearch
//
//  Created by Aravind Ashok kumar on 12/8/15.
//  Copyright (c) 2015 ISS. All rights reserved.
//

import UIKit
import CoreData

class FavouritesDetailView: UIViewController {

        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        @IBOutlet weak var imageTitle: UILabel!
        
        @IBOutlet weak var myImage: UIImageView!
        
        @IBOutlet weak var myComments: UITextField!
        
    var editingFavourites:Favourites!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageTitle.text = editingFavourites.title
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.myImage.addSubview(activityIndicator)
        activityIndicator.frame = self.myImage.bounds
        activityIndicator.startAnimating()
        let loadRequest = NSURLRequest(URL: NSURL(string: editingFavourites.imageURL )!)
        NSURLConnection.sendAsynchronousRequest(loadRequest,
            queue: NSOperationQueue.mainQueue()) {
                response, data, error in
                
                
                
                if error != nil {
                    // completion(flickrPhoto: self, error: error)
                    println(error)
                    return
                }
                
                if data != nil {
                    activityIndicator.removeFromSuperview()
                    let returnedImage = UIImage(data: data)
                    self.myImage.image = returnedImage
                   
                    return
                }
                
                // completion(flickrPhoto: self, error: nil)
        }
        //myImage.sizeToFit()
        
        myComments.text = editingFavourites.comments
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if(myComments.text != editingFavourites.comments && myComments.text != nil){
            
        editingFavourites.comments = myComments.text
        var error:NSError?
        managedObjectContext?.save(&error)
        if let err = error {
            println( err.localizedFailureReason)
            
        }
        else
        {
           // println("Saved")
            
        }
        
        }
        
    }
    

}
