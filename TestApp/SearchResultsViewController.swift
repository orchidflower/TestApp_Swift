//
//  SearchResultsViewController.swift
//  TestApp
//
//  Created by zhang on 14-6-13.
//  Copyright (c) 2014 zhang. All rights reserved.
//
import UIKit
import QuartzCore

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    var api: APIController?
    let kCellIdentifier: String = "SearchResultCell"
    var imageCache = NSMutableDictionary()
    // TabView object
    @IBOutlet var appsTableView : UITableView
    var albums: Album[] = []
    
    
    init(coder aCoder:NSCoder!) {
        super.init(coder:aCoder)
        self.api = APIController(delegate: self);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Search & show results
        api!.searchItunesFor("Bob Dylan");
    }
    

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        println("callback tableView. section \(section), count \(self.albums.count)")
        return self.albums.count
    }
    

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: kCellIdentifier)
        }
        
        let album: Album = self.albums[indexPath.row] as Album
        // Add a check to make sure this exists
        cell.text = album.title
        cell.image = UIImage(named: "Blank52")
        cell.detailTextLabel.text = album.price
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            // Jump into a background thread to get the image for this item
            // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
            let urlString = album.thumbnailImageURL
            // Check our image cache for the existing key. This is just a dictionary of UIImages
            var image: UIImage? = self.imageCache[urlString] as? UIImage
            
            if (!image?) {
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
                        
                        // Sometimes this request takes a while, and it's possible that a cell could be re-used before the art is done loading.
                        // Let's explicitly call the cellForRowAtIndexPath method of our tableView to make sure the cell is not nil, and therefore still showing onscreen.
                        // While this method sounds a lot like the method we're in right now, it isn't.
                        // Ctrl+Click on the method name to see how it's defined, including the following comment:
                        /** // returns nil if cell is not visible or index path is out of range **/
                        if let albumArtsCell: UITableViewCell? = tableView.cellForRowAtIndexPath(indexPath) {
                            albumArtsCell!.image = image
                        }
                    } else {
                        println("Error: \(error.localizedDescription)")
                    }
                })
            } else {
                cell.image = image
            }
        })
        return cell
    }
    
    
    func didRecieveAPIResults(results: NSDictionary) {
        // Store the results in our table data array
        if results.count>0 {
            
            let allResults: NSDictionary[] = results["results"] as NSDictionary[]
            
            // Sometimes iTunes returns a collection, not a track, so we check both for the 'name'
            for result: NSDictionary in allResults {
                
                var name: String? = result["trackName"] as? String
                if !name? {
                    name = result["collectionName"] as? String
                }
                
                // Sometimes price comes in as formattedPrice, sometimes as collectionPrice.. and sometimes it's a float instead of a string. Hooray!
                var price: String? = result["formattedPrice"] as? String
                if !price? {
                    price = result["collectionPrice"] as? String
                    if !price? {
                        var priceFloat: Float? = result["collectionPrice"] as? Float
                        var nf: NSNumberFormatter = NSNumberFormatter()
                        nf.maximumFractionDigits = 2;
                        if priceFloat? {
                            price = "$"+nf.stringFromNumber(priceFloat)
                        }
                    }
                }
                
                let thumbnailURL: String? = result["artworkUrl60"] as? String
                let imageURL: String? = result["artworkUrl100"] as? String
                let artistURL: String? = result["artistViewUrl"] as? String
                
                var itemURL: String? = result["collectionViewUrl"] as? String
                if !itemURL? {
                    itemURL = result["trackViewUrl"] as? String
                }
                var collectionId = result["collectionId"] as? Int
                
                var newAlbum = Album(name: name!, price: price!, thumbnailImageURL: thumbnailURL!, largeImageURL: imageURL!, itemURL: itemURL!, artistURL: artistURL!, collectionId: collectionId)
                albums.append(newAlbum)
            }
            
            
            dispatch_async(dispatch_get_main_queue(), {
                self.appsTableView.reloadData()
                })
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
            })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        var detailsViewController: DetailsViewController = segue.destinationViewController as DetailsViewController
        var albumIndex = appsTableView.indexPathForSelectedRow().row
        var selectedAlbum = self.albums[albumIndex]
        detailsViewController.album = selectedAlbum
    }

}
