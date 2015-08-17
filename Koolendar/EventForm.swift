//
//  EventForm.swift
//  Koolendar
//
//  Created by Chase on 2/10/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import UIKit
import SQLite

class EventForm: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var dateFieldStarting: UITextField!
    @IBOutlet weak var dateFieldEnding: UITextField!
    
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventDesc: UITextField!
    
    var startDateLegit: NSDate!
    var endDateLegit:NSDate!
    
    var hasClickedStart: dispatch_once_t = 0
    var hasClickedEnd: dispatch_once_t = 0
    
    var eventBeingEdited: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let comps = NSDateComponents()
        comps.day = SelectedDate.day
        comps.month = SelectedDate.month
        comps.year = SelectedDate.year
        
        let cal = NSCalendar.currentCalendar()
        let date = cal.dateFromComponents(comps)!
        
        if let eventBeingEdited = eventBeingEdited { loadEvent(eventBeingEdited) }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func loadEvent(event: Event) {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .ShortStyle
        
        dispatch_once(&hasClickedStart) {
            self.dateFieldStarting.text = timeFormatter.stringFromDate(event.startTime)
            self.startDateLegit = event.startTime
        }
        
        dispatch_once(&hasClickedEnd) {
            self.dateFieldEnding.text = timeFormatter.stringFromDate(event.endTime)
            self.endDateLegit = event.endTime
        }
        
        self.eventName.text = event.title
        self.eventDesc.text = event.description
    }
    
    @IBAction func dateFieldStart(sender: UITextField) {
        
        var datePickerStartView  : UIDatePicker = UIDatePicker()
        datePickerStartView.timeZone = NSCalendar.currentCalendar().timeZone
        datePickerStartView.calendar = NSCalendar.currentCalendar()
        datePickerStartView.datePickerMode = UIDatePickerMode.Time
        sender.inputView = datePickerStartView
        
        datePickerStartView.addTarget(self, action: Selector("handleDatePickerStart:"), forControlEvents: UIControlEvents.ValueChanged)
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .ShortStyle
        
        dispatch_once(&hasClickedStart) {
            let theDate = NSDate()
            self.dateFieldStarting.text = timeFormatter.stringFromDate(NSDate())
            self.startDateLegit = theDate
        }
    }
    
    func handleDatePickerStart(sender: UIDatePicker) {
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .ShortStyle
        dateFieldStarting.text = timeFormatter.stringFromDate(sender.date)
        startDateLegit = sender.date
    }
    
    // Oh shut up... I know its not efficient. i couldnt think of a simpler way to.
    @IBAction func dateFieldEnd(sender: UITextField) {
        
        var datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.timeZone = NSCalendar.currentCalendar().timeZone
        datePickerView.calendar = NSCalendar.currentCalendar()
        datePickerView.datePickerMode = UIDatePickerMode.Time
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: Selector("handleDatePickerEnd:"), forControlEvents: UIControlEvents.ValueChanged)
        
        let theDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: theDate)
        let hour = components.hour
        let minutes = components.minute
        
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .ShortStyle
        
        dispatch_once(&hasClickedEnd) {
            self.dateFieldEnding.text = timeFormatter.stringFromDate(theDate)
            
            self.endDateLegit = theDate
        }
        
    }
    
    func handleDatePickerEnd(sender: UIDatePicker) {
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .ShortStyle
        dateFieldEnding.text = timeFormatter.stringFromDate(sender.date)
        endDateLegit = sender.date
    }
    
    @IBAction func addEvent(sender: UIButton) {
        if let event = eventBeingEdited {
            event.title = eventName.text
            event.startTime = startDateLegit
            event.endTime = endDateLegit
            event.save()
        } else {
            let event = Event(title: eventName.text, description: eventDesc.text, startTime: startDateLegit, endTime: endDateLegit)
            event.save()
        }
        self.navigationController?.popViewControllerAnimated(true)
        
//        self.navigationController?.presentViewController(DayViewController(), animated: true, completion: nil)
        
//        if let resultController = storyboard?.instantiateViewControllerWithIdentifier("DayView") as? DayViewController {
//            presentViewController(resultController, animated: true, completion: nil)
//        }
        
    }
    
}
