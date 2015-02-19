//
//  DayViewController.swift
//  Koolendar
//
//  Created by Addison Bean on 1/21/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import UIKit
import CoreData
import SQLite

class DayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var tableData: [String] = ["We", "Heart", "Swift"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true
            ).first as String
        
        let db = Database("\(path)/KoolendarEventsList.sqlite3")
        let events = db["events"]
        let name = Expression<String>("name")
        let desc = Expression<String>("desc")
        let id   = Expression<Int>("id")
        db.create(table: events, ifNotExists: true) { t in
            t.column(id)
            t.column(name)
            t.column(desc)
        }
        
        return events.count
        
//        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true
            ).first as String
        
        let db = Database("\(path)/KoolendarEventsList.sqlite3")
        let events = db["events"]
        let id   = Expression<Int>("id")
        let name = Expression<String>("name")
        let desc = Expression<String>("desc")
        
        db.create(table: events, ifNotExists: true) { t in
            t.column(id)
            t.column(name)
            t.column(desc)
        }
        
        var eventsArray = Array(events)
        cell.textLabel?.text = "\(eventsArray[indexPath.row][name]) - \(eventsArray[indexPath.row][desc])"
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println(indexPath.row)
    }
    
    
    

    @IBAction func whatFreakinEvents(sender: UIButton) {
        
        
        println("yo, user wants to know whats goin down today")
        
        //        dude.hidden = true
        //        eventsOfLife.hidden = false
        
        
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true
            ).first as String
        
        let db = Database("\(path)/KoolendarEventsList.sqlite3")
        let events = db["events"]
        let name = Expression<String>("name")
        let desc = Expression<String>("desc")
        
        var testing: String = ""
        for user in events {
            testing = "\(testing)event name: \(user[name]) event desc: \(user[desc])"
            // id: 1, name: Optional("Alice"), email: alice@mac.com
        }
//        theEventsOfLife.text = testing
        
    }
   
    
}
