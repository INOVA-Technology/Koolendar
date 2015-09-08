//
//  SettingsViewController.swift
//  Koolendar
//
//  Created by Addison Bean on 8/22/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import UIKit

class SettingsViewController: CenterViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
//    var settings: [String: [String: Any]]!
    var settings = [(String, [(String, AnyObject)])]()
    
    override func viewDidLoad() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        settings.append(("Sounds", [("Sound Effects", userDefaults.boolForKey("sound_effects_enabled"))]))
    }
    
    @IBAction func showSidebar() {
        self.delegate?.toggleLeftPanel?()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings[section].1.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsTableViewCell", forIndexPath: indexPath) as! SettingsTableViewCell
        cell.title.text = self.settings[indexPath.section].1[indexPath.row].0
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.settings[section].0
    }
    
}
