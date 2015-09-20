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
    
    var delegate: ContainerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

}

extension SidePanelViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.delegate.sidePanelItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SidebarCell", forIndexPath: indexPath) as! SidePanelCell
        
        cell.name.text = self.delegate.sidePanelItems[indexPath.row].0
        
        return cell
    }
    
}

extension SidePanelViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if self.delegate.sidePanelItems[indexPath.row].2 == nil {
            let vc = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(self.delegate.sidePanelItems[indexPath.row].1) as! CenterViewController
            vc.delegate = self.delegate
            self.delegate.sidePanelItems[indexPath.row].2 = [vc]
            print("test")
        }
        
        self.delegate.centerNavigationController.viewControllers = self.delegate.sidePanelItems[indexPath.row].2!
        
        self.delegate.toggleLeftPanel()
    }
    
}
