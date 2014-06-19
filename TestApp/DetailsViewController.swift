//
//  DetailsViewController.swift
//  TestApp
//
//  Created by zhang on 14-6-19.
//  Copyright (c) 2014 zhang. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet var albumCover : UIImageView
    @IBOutlet var titleLabel : UILabel
    
    var album: Album?


    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = self.album?.title
        albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album?.largeImageURL)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
