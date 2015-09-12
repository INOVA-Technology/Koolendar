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
    
    var settings = [(String, [(String, Any)])]()
    
    override func viewDidLoad() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        settings.append(("Sounds", [("Sound Effects", userDefaults.boolForKey("sound_effects_enabled"))]))
        settings.append(("Interface", [("Color Scheme", colorSchemeValues as Any)]))
    }
    
    @IBAction func showSidebar() {
        self.delegate?.toggleLeftPanel?()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings[section].1.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsTableViewCell", forIndexPath: indexPath) as! SettingsTableViewCell
        let ugh = self.settings[indexPath.section].1[indexPath.row].0
        cell.title.text = ugh
        let obj: Any = self.settings[indexPath.section].1[indexPath.row].1
        if let val = obj as? Bool {
            println("ugh2")
            cell.setup(type: "Bool", options: val)
        } else if let vals = obj as? [(String, String)] {
            println("ugh")
            cell.setup(type: "MultiValue", options: (ugh, vals))
        } else {
            println("ugh3")
            println(obj)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.settings[section].0
    }
    
}
