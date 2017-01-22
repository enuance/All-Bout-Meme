//
//  FullScreenMemeController.swift
//  All-Bout Meme
//
//  Created by Stephen Martinez on 1/21/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit

class FullScreenMemeController: UIViewController {
    //StoryBoard ID for this is: FullScreenMeme
    @IBOutlet weak var fullScreenImage: UIImageView!
    
    var memeToDisplay: UIImage = UIImage()
    
    override func viewDidLoad() {super.viewDidLoad()
        fullScreenImage.image = memeToDisplay // This fixes the nil issue
    }
}
