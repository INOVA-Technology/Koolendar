//
//  SettingsViewController.swift
//  Koolendar
//
//  Created by Addison Bean on 8/22/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import UIKit

class SettingsViewController: CenterViewController, UITableViewDataSource, UITableViewDelegate {
    
    let settings = ["Notifications", "Color Scheme"]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    @IBAction func showSidebar() {
        self.delegate?.toggleLeftPanel?()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsTableViewCell", forIndexPath: indexPath) as! SettingsTableViewCell
        cell.title.text = settings[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("SettingsSubViewController") as! SettingsSubViewController
        vc.delegate = self.delegate
        vc.settingName = self.settings[indexPath.row]
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
}
