//
//  PlayersViewController.swift
//  TestApp
//
//  Created by zhang on 14-6-24.
//  Copyright (c) 2014 zhang. All rights reserved.
//

import UIKit

class PlayersViewController: UITableViewController, PlayerDetailsViewControllerDelegate {
    var players: Player[] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("hello, world!")
        println("TestApp is starting...")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        println("Memory low...")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1;
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.players.count;
    }
    
    func imageForRating(rating: Int)->UIImage  {
        switch rating {
        case 1:
            return UIImage(named: "1StarSmall")
        case 2:
            return UIImage(named: "2StarsSmall")
        case 3:
            return UIImage(named: "3StarsSmall")
        case 4:
            return UIImage(named: "4StarsSmall")
        default:
            return UIImage(named: "5StarsSmall")
        }
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let player = self.players[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier("PlayerCell") as PlayerCell
        cell.nameLabel.text = player.name
        cell.gameLabel.text = player.game
        cell.ratingImageView.image = self.imageForRating(player.rating)
        return cell
    }
    
    func playerDetailsViewControllerDidCancel(controller: PlayerDetailsViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func playerDetailsViewControllerDidSave(controller: PlayerDetailsViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier=="AddPlayer") {
            var navigationController = segue.destinationViewController as UINavigationController
            var playerDetailsViewController = navigationController.viewControllers[0] as PlayerDetailsViewController
            playerDetailsViewController.delegate = self
        }
    }
}
