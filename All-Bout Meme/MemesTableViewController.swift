//
//  MemesTableViewController.swift
//  All-Bout Meme
//
//  Created by Stephen Martinez on 1/18/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit

class MemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    override func viewDidLoad() {super.viewDidLoad()}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let placeHolder = UITableViewCell()
        return placeHolder
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
}
