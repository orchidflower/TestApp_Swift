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
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        cell.text = rowData["trackName"] as String
        
        // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
        var urlString: NSString = rowData["artworkUrl60"] as NSString
        var imgURL: NSURL = NSURL(string: urlString)
        
        // Download an NSData representation of the image at the URL
        var imgData: NSData = NSData(contentsOfURL: imgURL)
        cell.image = UIImage(data: imgData)
        
        // Get the formatted price string for display in the subtitle
        
        var formattedPrice: NSString = rowData["formattedPrice"] as NSString
        
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
}
