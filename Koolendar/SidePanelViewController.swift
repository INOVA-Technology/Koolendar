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
    
    struct TableView {
        struct CellIdentifiers {
            static let SidebarItemCell = "SidebarItemCell"
        }
    }
    
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
        let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.SidebarItemCell, forIndexPath: indexPath) as! SidebarItemCell
        return cell
    }
    
}
