//
//  MemeModel.swift
//  All-Bout Meme
//
//  Created by Stephen Martinez on 1/13/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit

// The meme object to be called when saving a meme
class Meme {
    let upperEntry: String
    let lowerEntry: String
    let originalImage: UIImage
    let memeImage: UIImage
    
    init(upperEntry: String, lowerEntry: String, originalImage: UIImage, memeImage: UIImage) {
        self.upperEntry = upperEntry
        self.lowerEntry = lowerEntry
        self.originalImage = originalImage
        self.memeImage = memeImage
    }
}

//Singleton Object for sharing model across MVC's.
class SentMemes{
    var memesList = [Meme]()
    static let shared = SentMemes()
    private init(){}
    
    class func clearMatches(){SentMemes.shared.memesList = [Meme]()}
}
