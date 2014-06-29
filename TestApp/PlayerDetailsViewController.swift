//
//  PlayerDetailsViewController.swift
//  TestApp
//
//  Created by zhang on 14-6-30.
//  Copyright (c) 2014 zhang. All rights reserved.
//

import UIKit

protocol PlayerDetailsViewControllerDelegate {
    func playerDetailsViewControllerDidCancel( controller: PlayerDetailsViewController)->Void
    func playerDetailsViewControllerDidSave(controller: PlayerDetailsViewController)->Void
}


class PlayerDetailsViewController: UITableViewController {
    var delegate: PlayerDetailsViewControllerDelegate?
    
    @IBAction func done(sender : AnyObject) {
        self.delegate!.playerDetailsViewControllerDidSave(self)
    }
    
    @IBAction func Cancel(sender : AnyObject) {
        self.delegate!.playerDetailsViewControllerDidCancel(self)
    }
}
