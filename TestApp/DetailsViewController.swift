//
//  DetailsViewController.swift
//  TestApp
//
//  Created by zhang on 14-6-19.
//  Copyright (c) 2014 zhang. All rights reserved.
//

import UIKit
import MediaPlayer
import QuartzCore

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol  {
    var mediaPlayer: MPMoviePlayerController = MPMoviePlayerController()
    
    @IBOutlet var albumCover : UIImageView
    @IBOutlet var titleLabel : UILabel
    @IBOutlet var tracksTableView : UITableView
    
    var album: Album?
    var tracks: Track[] = []
    @lazy var api: APIController = APIController(delegate: self)

    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = self.album?.title
        albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album?.largeImageURL)))
        
        // Load in tracks
        if self.album?.collectionId? {
            api.lookupAlbum(self.album!.collectionId!)
        }
    }

    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("TrackCell") as TrackCell
        
        var track = tracks[indexPath.row]
        cell.titleLabel.text = track.title
        cell.playIcon.text = "▶️"
        
        return cell
    }
    
    func didRecieveAPIResults(results: NSDictionary) {
        if let allResults = results["results"] as? NSDictionary[] {
            for trackInfo in allResults {
                // Create the track
                if let kind = trackInfo["kind"] as? String {
                    if kind=="song" {
                        var track = Track(dict: trackInfo)
                        tracks.append(track)
                    }
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.tracksTableView.reloadData()
        })
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var track = tracks[indexPath.row]
        mediaPlayer.stop()
        mediaPlayer.contentURL = NSURL(string: track.previewUrl)
        mediaPlayer.play()
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TrackCell {
            cell.playIcon.text = "▪️"
        }
    }
    
    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
            })
    }
}
