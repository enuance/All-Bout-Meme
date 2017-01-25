//
//  MemesCollectionViewController.swift
//  All-Bout Meme
//
//  Created by Stephen Martinez on 1/18/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit

class MemesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var makeMemeMessage: UILabel!
    @IBOutlet weak var memesCollection: UICollectionView!
    @IBOutlet weak var memesLayout: UICollectionViewFlowLayout!
    let cellDesign = MemeStyle()
    
    //Checks Device Orientation and formats the layout accordingly
    func layoutSetter(checkBeforeTransition: Bool, _ size: CGSize!){
        //Arbitrary Number for space between cells
        let spaceSize: CGFloat = 4.0
        let width: CGFloat
        let height: CGFloat
        switch checkBeforeTransition {
        case true:
            width = size.width
            height = size.height
        case false:
            width = view.frame.size.width
            height = view.frame.size.height
        }
        let cellInRowCount: CGFloat = (width < height ? 3 : 5)
        let spaceCount: CGFloat = cellInRowCount - 1
        //Fomula for creating uniform sized squared memes and lines in between
        let dimension: CGFloat = (width - (spaceCount * spaceSize)) / cellInRowCount
        memesLayout.minimumInteritemSpacing = spaceSize
        memesLayout.minimumLineSpacing = spaceSize
        memesLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        layoutSetter(checkBeforeTransition: true, size)
    }
    
    override func viewDidLoad() {super.viewDidLoad()
        layoutSetter(checkBeforeTransition: false, nil)
    }
    
    //Sets the initial/default appearance of the CollectionView
    override func viewWillAppear(_ animated: Bool) {
        layoutSetter(checkBeforeTransition: false, nil)
        if SentMemes.shared.memesList.count != 0 {
            makeMemeMessage.alpha = 0
        }
        //Reloads the CollectionView's data each time it's brought up to Screen.
        memesCollection.reloadData()
        tabBarController?.tabBar.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SentMemes.shared.memesList.count
    }
    
    //Formats all the memes to be viewed in the collection.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let image = SentMemes.shared.memesList[indexPath.row].originalImage
        let topText = SentMemes.shared.memesList[indexPath.row].upperEntry
        let bottomText = SentMemes.shared.memesList[indexPath.row].lowerEntry
        let style = SentMemes.shared.memesList[indexPath.row].memeStyle
        let memeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemesCollectionCell", for: indexPath) as! MemesCollectionCell
        memeCell.cellImage.image = image
        memeCell.topCellEntry.text = topText
        memeCell.topCellEntry.font = cellDesign.fontForStyle(style, size: .Cell)
        memeCell.bottomCellEntry.text = bottomText
        memeCell.bottomCellEntry.font = cellDesign.fontForStyle(style, size: .Cell)
        memeCell.layer.cornerRadius = 4
        return memeCell
    }
    
    //Navigate to a scrollable/Zoomable fullscreen view of the meme selected from the collection.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let fullScreenVC = storyboard.instantiateViewController(withIdentifier: "FullScreenMeme") as! FullScreenMemeController
        let memePic = SentMemes.shared.memesList[indexPath.row].memeImage
        fullScreenVC.memeToDisplay = memePic
        tabBarController?.tabBar.isHidden = true
        navigationController!.pushViewController(fullScreenVC, animated: true)
    }
    
    //Navigate to the Meme Editor in order to create a new Meme.
    @IBAction func composeMeme(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let memeEditorVC = storyboard.instantiateViewController(withIdentifier: "memeEditor") as! MemeController
        tabBarController?.tabBar.isHidden = true
        navigationController!.pushViewController(memeEditorVC, animated: true)
    }
}
