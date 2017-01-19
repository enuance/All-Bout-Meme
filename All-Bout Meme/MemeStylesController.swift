//
//  MemeStylesController.swift
//  All-Bout Meme
//
//  Created by Stephen Martinez on 1/17/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit

class MemeStylesController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    //Use tuples here instead in order to index more accurately through data type.

    let styles = MemeStyle()
    
    weak var delegate: StyleSelectionDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let stylesMenu = styles.menu
        return stylesMenu.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stylesMenu = styles.menu
        let chosenStyle = stylesMenu[indexPath.row].styleType
        delegate?.didSelectStyle(chosenStyle)
        //Passing Info Through Our Custom Delegate and backwards through the Navigation Stack.
        navigationController!.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let theStyleCell = tableView.dequeueReusableCell(withIdentifier: "StyleCell")!
        
        let stylesMenu = styles.menu
        let styleName = stylesMenu[indexPath.row].displayName
        let styleDescription = stylesMenu[indexPath.row].description
        let styleType = stylesMenu[indexPath.row].styleType
        
        theStyleCell.textLabel?.text = styleName
        theStyleCell.detailTextLabel?.text = styleDescription
        theStyleCell.textLabel?.font = styles.fontForStyle(styleType, size: .Big)
        theStyleCell.detailTextLabel?.font = styles.fontForStyle(styleType, size: .Small)
        
        return theStyleCell
    }
    
    
}
