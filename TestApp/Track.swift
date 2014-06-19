//
//  Track.swift
//  TestApp
//
//  Created by zhang on 14-6-19.
//  Copyright (c) 2014 zhang. All rights reserved.
//

import Foundation

class Track {
    
    var title: String?
    var price: String?
    var previewUrl: String?
    
    init(dict: NSDictionary!) {
        self.title = dict["trackName"] as? String
        self.price = dict["trackPrice"] as? String
        self.previewUrl = dict["previewUrl"] as? String
    }
}