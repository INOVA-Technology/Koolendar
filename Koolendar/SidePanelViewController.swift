//
//  SidePanelViewController.swift
//  Koolendar
//
//  Created by Addison Bean on 8/18/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import UIKit

class SidePanelViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

}

extension SidePanelViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SidebarItemCell", forIndexPath: indexPath) as! UITableViewCell
        return cell
    }
    
}
