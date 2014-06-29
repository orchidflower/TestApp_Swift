//
//  Player.swift
//  TestApp
//
//  Created by zhang on 14-6-24.
//  Copyright (c) 2014 zhang. All rights reserved.
//

import Foundation

class Player {
    var name: String;
    var game: String;
    var rating: Int;
    
    init(name:String, game: String, rating: Int) {
        self.name = name;
        self.game = game;
        self.rating = rating;
    }
}