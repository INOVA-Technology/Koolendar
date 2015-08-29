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
    
    var settings: [String: [String: Any]]!
    
    override func viewDidLoad() {
        println(loadData())
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func loadData(_ tryAgainOnFailure: Bool = true) -> Bool {
        var success = false
        
        if let path = NSBundle.mainBundle().pathForResource("settings.json", ofType: "json") {
            if let data = NSData(contentsOfFile: path, options: NSDataReadingOptions(), error: nil) {
                if let _settings = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(), error: nil) as? [String: [String: Any]] {
                    success = true
                    self.settings = _settings
                    return true
                }
            }
        }
        
        if !success && tryAgainOnFailure {
            // if this is reached that means the settings are corrupt or don't exist, so we'll just load the default settings
            // but I feel like we should also backup the old one if it was corrupted
            let source = NSBundle.mainBundle().pathForResource("default_settings", ofType: "json")!
            
//            let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
//            let dest = dir.stringByAppendingPathComponent("settings.json")
            let dest = NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("settings.json")
            
            println(source)
            println(dest)
            
            var error: NSError?
            NSFileManager.defaultManager().copyItemAtPath(source, toPath: dest, error: &error)
            
            if let error = error {
                println(error)
            }
            
            return loadData(false)
        }
        
        return false
    }
    
    @IBAction func showSidebar() {
        self.delegate?.toggleLeftPanel?()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return settings.count
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsTableViewCell", forIndexPath: indexPath) as! SettingsTableViewCell
        cell.title.text = settings.keys.array[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("SettingsSubViewController") as! SettingsSubViewController
        vc.delegate = self.delegate
        vc.settingName = self.settings.keys.array[indexPath.row]
        vc.settings = self.settings[vc.settingName]
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
}
