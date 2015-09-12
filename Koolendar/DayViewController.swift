//
//  DayViewController.swift
//  Koolendar
//
//  Created by Addison Bean on 1/21/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import UIKit
import CoreData
import EventKit

class DayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    

    @IBOutlet weak var theDateText: UILabel!
    var events = [Event]()
    
    var selectedCellIndexPath: NSIndexPath?
    
    let SelectedCellHeight: CGFloat = 200.0
    let UnselectedCellHeight: CGFloat = 70.0
    
    var day: NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIImageView(image: ColorScheme.background)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let cal = NSCalendar.currentCalendar()
        let comps = NSDateComponents()
        comps.day = SelectedDate.day
        comps.month = SelectedDate.month
        comps.year = SelectedDate.year
        self.day = cal.dateFromComponents(comps)!
        self.events = Event.eventsOnDate(day)
        
        theDateText.text = "\(SelectedDate.month)/\(SelectedDate.day)/\(SelectedDate.year)"
        
        self.tableView.reloadData()
    }
    
    @IBAction func goBack(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func eatThis(sender: UIButton) {
        theDateText.text = "\(SelectedDate.month)/\(SelectedDate.day)/\(SelectedDate.year)"
    }
    
    // MARK: Table View Stuff
    
    func tableView(UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("eventCell") as! EventCell
        
        let event = events[indexPath.row]
        
        cell.eventTitle.text = event.title
        cell.eventDescription.text = event.description
        
        if event.allDay {
            cell.eventTime.text = "All day"
        } else {
            let cal = NSCalendar.currentCalendar()
            let units: NSCalendarUnit = .CalendarUnitHour | .CalendarUnitMinute
            
            let startComps = cal.components(units, fromDate: event.startTime)
            let endComps = cal.components(units, fromDate: event.endTime)
            
            let formatter = NSDateFormatter()
            formatter.dateStyle = .NoStyle
            formatter.timeStyle = .ShortStyle
            cell.eventTime.text = formatter.stringFromDate(event.startTime)
        }
        
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = ColorScheme.dayCellEven
        } else {
            cell.backgroundColor = ColorScheme.dayCellOdd
            cell.textLabel?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        }
        
        return cell
    }
    
    func tableView(UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let selectedCellIndexPath = selectedCellIndexPath {
            if selectedCellIndexPath == indexPath {
                self.selectedCellIndexPath = nil
            } else {
                self.selectedCellIndexPath = indexPath
            }
        } else {
            selectedCellIndexPath = indexPath
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    // wait this method declaration is really weird, idk how it even works
    func tableView(UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.Delete) {
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
       
        var editAction = UITableViewRowAction(style: .Normal, title: "Edit") { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            self.editEventWithIndex(indexPath.row)
        }
        
        var deleteAction = UITableViewRowAction(style: .Normal, title: "Delete") { action, indexPath in
            self.deleteEventWithIndex(indexPath.row)
        }
        
        editAction.backgroundColor = UIColor.lightGrayColor()
        deleteAction.backgroundColor = UIColor.redColor()
        
        return [deleteAction, editAction]
        
    }
    
    func reloadEvents() {
        self.events = Event.eventsOnDate(self.day)
        self.tableView.reloadData()
    }
    
    func tableView(UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let selectedCellIndexPath = selectedCellIndexPath {
            if selectedCellIndexPath == indexPath {
                return SelectedCellHeight
            }
        }
        return UnselectedCellHeight
    }
    
    func deleteEventWithIndex(index: Int) {
        self.events[index].delete()
        
        UIView.animateWithDuration(0.4, animations: {
            let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            cell?.alpha = 0
        }, completion: { _ in
            self.reloadEvents()
        })
    }
    
    func editEventWithIndex(index: Int) {
        let eventForm = self.storyboard!.instantiateViewControllerWithIdentifier("EventFormViewController") as! EventForm
        eventForm.event = self.events[index]
        self.navigationController!.pushViewController(eventForm, animated: true)
    }
    
    @IBAction func createEvent() {
        let vc = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("EventFormViewController") as! EventForm
        vc.event = Event(day: SelectedDate.day, month: SelectedDate.month, year: SelectedDate.year)
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
}
