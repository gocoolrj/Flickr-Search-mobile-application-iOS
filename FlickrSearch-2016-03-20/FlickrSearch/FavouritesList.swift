//
//  FavouritesList.swift
//  FlickrSearch
//
//  Created by Aravind Ashok kumar on 11/8/15.
//  Copyright (c) 2015 ISS. All rights reserved.
//

import UIKit
import CoreData

class FavouritesList: UITableViewController {

    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var favourtitesObject : Favourites!
    
    var photos = [Favourites] ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        loadAll()
        //tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadAll()
    }
    

    // MARK: - Table view data source
    
    
    func loadAll()
    {
        photos.removeAll(keepCapacity: false)
        let entityDescription = NSEntityDescription.entityForName("Favourites", inManagedObjectContext:managedObjectContext!)
        let request = NSFetchRequest()
        request.entity = entityDescription
        var error : NSError?
        var result = managedObjectContext?.executeFetchRequest(request, error:&error)
        
        for resultItem in result! {
            var photoItem = resultItem as! Favourites
            
            photos.append(photoItem)
        }
        self.tableView.reloadData()
        
        
    }
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return photos.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("favCell", forIndexPath: indexPath) as! UITableViewCell

//        
        // Configure the cell...
        cell.textLabel!.text = photos[indexPath.row].title
        cell.detailTextLabel!.text = photos[indexPath.row].imageURL
        
       // println("\(cell.textLabel!.text)")

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let photo = photos[indexPath.row] as Favourites
                
                //println("Course - ID Selected: \(photo.courseID)");
                (segue.destinationViewController as! FavouritesDetailView).editingFavourites = photo
            }
        }
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        var error:NSError?
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            favourtitesObject = photos[indexPath.row]
            managedObjectContext?.deleteObject(favourtitesObject)
            photos.removeAtIndex(indexPath.row);
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        managedObjectContext?.save(&error)
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
