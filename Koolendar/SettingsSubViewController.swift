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
        tableView.dataSource = self
        println(self.settings)
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