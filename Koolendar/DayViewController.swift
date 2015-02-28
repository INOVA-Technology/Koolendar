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
    
    @IBOutlet weak var koolDetails: UILabel!

    @IBOutlet weak var theDateText: UILabel!
    var events: [Event]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 70;
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "SimpleBg"))
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        events = EventManager().eventsForDay(SelectedDate.day, month: SelectedDate.month, year:SelectedDate.year)
        
        theDateText.text = "\(SelectedDate.month)/\(SelectedDate.day)/\(SelectedDate.year)"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func eatThis(sender: UIButton) {
        theDateText.text = "\(SelectedDate.month)/\(SelectedDate.day)/\(SelectedDate.year)"
         println("faskf;lkasdf;kas \(SelectedDate.month)")
    }
    
    @IBAction func whatFreakinEvents(sender: UIButton) {
        // do we still need this?
    }
    
    // MARK: Table View Stuff
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        
        let event = events[indexPath.row]
        
        cell.textLabel?.text = "\(event.name) - \(event.desc)"
        
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.clearColor()
        } else {
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
            cell.textLabel?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        let event = events[indexPath.row]
        
//        koolDetails.text = event.desc  // jacks function below ⬇︎
        
        UIView.animateWithDuration(0.7, delay: 1.0, options: .CurveEaseOut, animations: {

            var theTop = self.tableView.frame

            
            theTop.origin.y += 250
            
            self.tableView.frame.origin.y = theTop.origin.y
            }, completion: { finished in
                println("animated bruh")
        })
    }
   
    
}
