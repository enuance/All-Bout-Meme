//
//  MemesCollectionViewController.swift
//  All-Bout Meme
//
//  Created by Stephen Martinez on 1/18/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit

class MemesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let cellDesign = MemeStyle()
    
    @IBOutlet weak var makeMemeMessage: UILabel!
    @IBOutlet weak var memesCollection: UICollectionView!
    @IBOutlet weak var memesLayout: UICollectionViewFlowLayout!
    
    
    func layoutSetter(checkBeforeTransition: Bool, _ size: CGSize!){
        let spaceSize: CGFloat = 4.0
        //Arbitrary Number for space between cells
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
        let dimension: CGFloat = (width - (spaceCount * spaceSize)) / cellInRowCount
        memesLayout.minimumInteritemSpacing = spaceSize
        memesLayout.minimumLineSpacing = spaceSize
        memesLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        layoutSetter(checkBeforeTransition: true, size)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSetter(checkBeforeTransition: false, nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        layoutSetter(checkBeforeTransition: false, nil)
        if SentMemes.shared.memesList.count != 0 {
            makeMemeMessage.alpha = 0
        }
        self.memesCollection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SentMemes.shared.memesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let memeImage = SentMemes.shared.memesList[indexPath.row].originalImage
        let memeTopEntry = SentMemes.shared.memesList[indexPath.row].upperEntry
        let memeBottomEntry = SentMemes.shared.memesList[indexPath.row].lowerEntry
        let memeStyle = SentMemes.shared.memesList[indexPath.row].memeStyle
        
        let memeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemesCollectionCell", for: indexPath) as! MemesCollectionCell
        memeCell.cellImage.image = memeImage
        memeCell.topCellEntry.text = memeTopEntry
        memeCell.topCellEntry.font = cellDesign.fontForStyle(memeStyle, size: .Cell)
        memeCell.bottomCellEntry.text = memeBottomEntry
        memeCell.bottomCellEntry.font = cellDesign.fontForStyle(memeStyle, size: .Cell)
        memeCell.layer.cornerRadius = 4
        return memeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let fullScreenVC = storyboard.instantiateViewController(withIdentifier: "FullScreenMeme") as! FullScreenMemeController
        
        print("indexPath.row is \(indexPath.row)")
        print(SentMemes.shared.memesList.count)
        let memePic = SentMemes.shared.memesList[indexPath.row].memeImage
        print(memePic)
        
        fullScreenVC.memeToDisplay = memePic // Dont access nil props even if your trying to set from here!
        
        navigationController!.pushViewController(fullScreenVC, animated: true)
    }
    
    @IBAction func composeMeme(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let memeEditorVC = storyboard.instantiateViewController(withIdentifier: "memeEditor") as! MemeController
        
        tabBarController?.tabBar.isHidden = true
        navigationController!.pushViewController(memeEditorVC, animated: true)
    }
    
}
