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
    
    @IBOutlet weak var theEventsOfLife: UILabel!
    @IBOutlet weak var dude: UIImageView!
    //    @IBOutlet weak var eventsOfLife: UILabel!
    @IBOutlet weak var eventList: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//         this crashes it, idk if we need it
        // self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
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

        db.create(table: events, ifNotExists: true) { t in
            t.column(name)
            t.column(desc)
        }
        
        return events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = eventList.dequeueReusableCellWithIdentifier("eventCell") as UITableViewCell
        
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
        
//        cell.textLabel?.text = events.select(name).filter(id == indexPath.row).first![events[id]]
        cell.textLabel?.text = "UGGHH"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
        theEventsOfLife.text = testing
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
