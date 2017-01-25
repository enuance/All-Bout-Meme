//
//  FullScreenMemeController.swift
//  All-Bout Meme
//
//  Created by Stephen Martinez on 1/21/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit

class FullScreenMemeController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var fullScreenImage: UIImageView!
    @IBOutlet weak var fullScreenScroll: UIScrollView!
    var memeToDisplay: UIImage = UIImage()
    
    //Sets up the View for a Scrollable/Zoomable FullScreen View of Selected Meme
    override func viewDidLoad() {super.viewDidLoad()
        fullScreenImage.image = memeToDisplay
        fullScreenScroll.delegate = self
        fullScreenScroll.minimumZoomScale = 1.0
        fullScreenScroll.maximumZoomScale = 5.0
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fullScreenImage
    }
}
