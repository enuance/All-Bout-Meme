//
//  MemesTableViewController.swift
//  All-Bout Meme
//
//  Created by Stephen Martinez on 1/18/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit
import CoreData

class MemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var makeMemeMessage: UILabel!
    @IBOutlet weak var memeTableView: UITableView!
    //let memesSent = SentMemes.shared.memesList
    let cellDesign = MemeStyle()
    
    //Sets the initial/default appearance of the TableView
    override func viewWillAppear(_ animated: Bool) {super.viewWillAppear(animated)
        SentMemes.loadFromDB()
        if SentMemes.shared.memesList.count != 0 {makeMemeMessage.alpha = 0}
        //Reloads the TableView's data each time it's brought up to Screen.
        memeTableView.reloadData()
        tabBarController?.tabBar.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SentMemes.shared.memesList.count
    }
    
    //Formats all the memes to be viewed in the collection.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let image = SentMemes.shared.memesList[indexPath.row].originalImage!
        let topText = SentMemes.shared.memesList[indexPath.row].upperEntry!
        let bottomText = SentMemes.shared.memesList[indexPath.row].lowerEntry!
        let style = SentMemes.shared.memesList[indexPath.row].memeStyle!
        
        
        let memeCell = tableView.dequeueReusableCell(withIdentifier: "MemesTableCell", for: indexPath) as! MemesTableCell
        memeCell.tableMemeImage.image = UIImage(data: image as Data)
        memeCell.tableMemeTopEntry.text = topText
        memeCell.tableMemeTopEntry.font = cellDesign.fontForStyle(MemeCnst.styleFor(style), size: .Big)
        memeCell.tableMemeBottomEntry.text = bottomText
        memeCell.tableMemeBottomEntry.font = cellDesign.fontForStyle(MemeCnst.styleFor(style), size: .Big)
        memeCell.tableMemeImage.layer.cornerRadius = 4
        return memeCell
    }
    
    //Navigate to a scrollable/Zoomable fullscreen view of the meme selected from the table.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let fullScreenVC = storyboard.instantiateViewController(withIdentifier: "FullScreenMeme") as! FullScreenMemeController
        let memePic = SentMemes.shared.memesList[indexPath.row].memeImage!
        let memeUniqueID = SentMemes.shared.memesList[indexPath.row].uniqueID!
        fullScreenVC.memeToDisplay = UIImage(data: memePic as Data)!
        fullScreenVC.memeUniqueID = memeUniqueID
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















