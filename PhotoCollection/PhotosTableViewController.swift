//
//  PhotosTableViewController.swift
//  PhotoCollection
//
//  Created by Dale Musser on 10/19/15.
//  Copyright © 2015 Swift Developer Academy. All rights reserved.
//
// definesPresentationContext - needed to hide search bar when segue occurs
// http://stackoverflow.com/questions/29472011/uisearchcontroller-persisting-after-segue
// 
// Add editing buttons to table view cells
// http://www.raywenderlich.com/62435/make-swipeable-table-view-cell-actions-without-going-nuts-scroll-views
// http://www.raywenderlich.com/77974/making-a-gesture-driven-to-do-list-app-like-clear-in-swift-part-1
// http://blog.apoorvmote.com/uitableviewcell-swipe-custom-button-ios-9-swift/

import UIKit

class PhotosTableViewController: UITableViewController, UISearchResultsUpdating {
    let photoCollection = PhotoCollection.sharedInstance //Singleton an instance of an object that allows other objects to ask for the information. Holds 1 instance of the json and can be asked for it. sharedInstance is the model/ static method of the app
    var filteredPhotos: [Photo]!
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Photo List"

        filteredPhotos = photoCollection.photos
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        //self.tableView?.tableHeaderView?.hidden = false
        //searchController.searchBar.hidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        //self.tableView?.tableHeaderView?.hidden = true
        //searchController.searchBar.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredPhotos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("photocell", forIndexPath: indexPath) as! PhotoTableViewCell
        
        let photo = filteredPhotos[indexPath.row]
        cell.imageTitle.text = photo.title
        cell.imageDescription.text = photo.description
        cell.thumbnailImageView.image = UIImage(named: photo.fileName)
        
        cell.accessoryType = .DisclosureIndicator//This is an enum if no confusion you can do just .nameOfEnum otherswise name.NameOfEnum

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller:PhotoViewController = segue.destinationViewController as! PhotoViewController
        
        if let row = self.tableView.indexPathForSelectedRow?.row {
            controller.photo = filteredPhotos[row]
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredPhotos = photoCollection.filter(searchText)
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let rateAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Rate") { (action , indexPath ) -> Void in
            self.editing = false
            print("Rate button pressed")
        }
        rateAction.backgroundColor = UIColor(red: 0, green: 0.8, blue: 0, alpha: 1.0)
        
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Share") { (action , indexPath) -> Void in
            self.editing = false
            print("Share button pressed")
        }
        shareAction.backgroundColor = UIColor.blueColor()
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete") { (action , indexPath) -> Void in
            self.editing = false
            print("Delete button pressed")
            self.filteredPhotos.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        deleteAction.backgroundColor = UIColor.redColor()
        return [rateAction, shareAction, deleteAction]
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            filteredPhotos.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
