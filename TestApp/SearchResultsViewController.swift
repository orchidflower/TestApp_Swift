//
//  SearchResultsViewController.swift
//  TestApp
//
//  Created by zhang on 14-6-13.
//  Copyright (c) 2014 zhang. All rights reserved.
//
import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    var api: APIController?
    let kCellIdentifier: String = "SearchResultCell"
    var imageCache = NSMutableDictionary()
    
    init(coder aCoder:NSCoder!) {
        super.init(coder:aCoder)
        self.api = APIController(delegate: self);
    }
    
    // TabView object
    @IBOutlet var appsTableView : UITableView
    var tableData: NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Search & show results
        api!.searchItunesFor("Angry Birds");
    }
    

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        println("callback tableView. section \(section), count \(tableData.count)")
        return tableData.count
    }
    

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: kCellIdentifier)
        }
        
        var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        // Add a check to make sure this exists
        let cellText:String? = rowData["trackName"] as? String
        cell.text = cellText
        cell.image = UIImage(named: "Blank52")
        
        var formattedPrice: NSString = rowData["formattedPrice"] as NSString
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            // Jump into a background thread to get the image for this item
            // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
            var urlString: NSString = rowData["artworkUrl60"] as NSString
            // Check our image cache for the existing key. This is just a dictionary of UIImages
            var image: UIImage? = self.imageCache.valueForKey(urlString) as? UIImage
            
            if (!image) {
                // If the image does not exists, we need to download it
                var imgURL:NSURL = NSURL(string:urlString)
                // Download an NSData representation of the image of the URL
                var request:NSURLRequest = NSURLRequest(URL:imgURL)
                var urlConnection:NSURLConnection = NSURLConnection(request:request, delegate:self)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response:NSURLResponse!, data:NSData!, error:NSError!)->Void in
                    if !error? {
                        // var imgData:NSData = NSData(contentsOfURL:imgUrl)
                        image = UIImage(data:data)
                        //Store the image into our cache
                        self.imageCache.setValue(image, forKey: urlString)
                        cell.image = image
                    } else {
                        println("Error: \(error.localizedDescription)")
                    }
                })
            } else {
                cell.image = image
            }
        })
        cell.detailTextLabel.text = formattedPrice
        return cell
    }
    
    
    func didRecieveAPIResults(results: NSDictionary) {
        println("Received result. Count \(results.count)")
        // Store the results in our table data array
        if results.count>0 {
            self.tableData = results["results"] as NSArray
            self.appsTableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        
        
        // Get the row data for the selected row
        
        var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        println(rowData)
        
        
        
        var name: String = rowData["trackName"] as String
        
        var formattedPrice: String = rowData["formattedPrice"] as String
        
        
        
        var alert: UIAlertView = UIAlertView()
        
        alert.title = name
        
        alert.message = formattedPrice
        
        alert.addButtonWithTitle("Ok")
        
        alert.show()
        
        
        
    }
}
