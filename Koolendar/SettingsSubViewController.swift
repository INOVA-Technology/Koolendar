//
//  SettingsSubViewController.swift
//  Koolendar
//
//  Created by Addison Bean on 8/25/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import UIKit

class SettingsSubViewController: CenterViewController {

    @IBOutlet weak var tableView: UITableView!
    var settingName: String!
    var settings: [String: Any]!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.dataSource = self
    }
    
    func loadData(_ tryAgainOnFailure: Bool = true) -> Bool {
        var success = false
        
        if let path = NSBundle.mainBundle().pathForResource("settings.json", ofType: "json") {
            if let data = NSData(contentsOfFile: path, options: NSDataReadingOptions(), error: nil) {
                if let allSettings = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(), error: nil) as? [String: [String: Any]] {
                    success = true
                    settings = allSettings[self.settingName]
                    return true
                }
            }
        }
        
        if !success && tryAgainOnFailure {
            // if this is reached that means the settings are corrupt or don't exist, so we'll just load the default settings
            // but I feel like we should also backup the old one if it was corrupted
            let source = NSBundle.mainBundle().pathForResource("default_settings", ofType: "json")!
            
            let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
            let dest = dir.stringByAppendingPathComponent("settings.json")
            
            NSFileManager.defaultManager().copyItemAtPath(source, toPath: dest, error: nil)
            return loadData(false)
        }
        
        return false
    }
    
    @IBAction func goBack() {
        self.navigationController!.popViewControllerAnimated(true)
    }
}

extension SettingsSubViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsSubViewCell", forIndexPath: indexPath) as! UITableViewCell
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let c = self.settings?.count {
            return c
        } else {
            return 0
        }
    }
    
}