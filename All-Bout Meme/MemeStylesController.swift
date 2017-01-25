//
//  MemeStylesController.swift
//  All-Bout Meme
//
//  Created by Stephen Martinez on 1/17/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit

//Controlls a TableView that shows Meme Styles to choose from.
class MemeStylesController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    let styles = MemeStyle()
    let stylesMenu = MemeStyle().menu
    //Custom Delegate property
    weak var delegate: StyleSelectionDelegate? = nil

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stylesMenu.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenStyle = stylesMenu[indexPath.row].styleType
        //Passing data backwards through NavigationStack using custom delegate.
        delegate?.didSelectStyle(chosenStyle)
        navigationController!.popViewController(animated: true)
    }
    
    //Formating all cells to display the items in our Style Menu
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let theStyleCell = tableView.dequeueReusableCell(withIdentifier: "StyleCell")!
        let cellFormat = stylesMenu[indexPath.row]
        theStyleCell.textLabel?.text = cellFormat.displayName
        theStyleCell.detailTextLabel?.text = cellFormat.description
        theStyleCell.textLabel?.font = styles.fontForStyle(cellFormat.styleType, size: .Big)
        theStyleCell.detailTextLabel?.font = styles.fontForStyle(cellFormat.styleType, size: .Small)
        return theStyleCell
    }
}
