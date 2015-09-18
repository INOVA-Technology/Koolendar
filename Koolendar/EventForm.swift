//
//  EventForm.swift
//  Koolendar
//
//  Created by Chase on 2/10/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import UIKit
import SQLite

// THIS IS A MESS, proceed with caution

class EventForm: UIViewController, UITextFieldDelegate, NotificationTimeOffsetViewControllerDelegate {
    
    @IBOutlet weak var dateFieldStarting: UITextField!
    @IBOutlet weak var dateFieldEnding: UITextField!
    
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventDesc: UITextField!
    
    @IBOutlet weak var timeOffsetLabel: UIButton!
    
    var timeOffsetLabelText: String {
        get { return timeOffsetLabel.titleLabel!.text! }
        set { timeOffsetLabel.setTitle(newValue, forState: UIControlState.Normal) }
    }
    
    var startDateLegit: NSDate!
    var endDateLegit:NSDate!
    
    var hasClickedStart: dispatch_once_t = 0
    var hasClickedEnd: dispatch_once_t = 0
    
    var event: Event!
    
    var datePickerStartView: UIDatePicker = UIDatePicker()
    var datePickerEndView: UIDatePicker = UIDatePicker()
    
    var offsets: [(String, CFTimeInterval)]!
    
    var selectedOffsetIndex: Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let comps = NSDateComponents()
        comps.day = SelectedDate.day
        comps.month = SelectedDate.month
        comps.year = SelectedDate.year
        
        loadEventInfo()
        
        datePickerStartView.timeZone = NSCalendar.currentCalendar().timeZone
        datePickerStartView.calendar = NSCalendar.currentCalendar()
        datePickerStartView.datePickerMode = UIDatePickerMode.Time
        datePickerStartView.addTarget(self, action: Selector("handleDatePickerStart:"), forControlEvents: UIControlEvents.ValueChanged)
        
        datePickerEndView.timeZone = NSCalendar.currentCalendar().timeZone
        datePickerEndView.calendar = NSCalendar.currentCalendar()
        datePickerEndView.datePickerMode = UIDatePickerMode.Time
        datePickerEndView.addTarget(self, action: Selector("handleDatePickerEnd:"), forControlEvents: UIControlEvents.ValueChanged)
        
        self.offsets = [("0 minutes", 0), ("1 minutes", 60), ("5 minutes", 300), ("10 minutes", 600), ("15 minutes", 900), ("30 minutes", 1800), ("1 hour", 3600), ("1 day", 43200)]
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func loadEventInfo() {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .ShortStyle
        
        dispatch_once(&hasClickedStart) {
            self.dateFieldStarting.text = timeFormatter.stringFromDate(self.event.startTime)
            self.startDateLegit = self.event.startTime
            self.datePickerStartView.date = self.event.startTime
        }
        
        dispatch_once(&hasClickedEnd) {
            self.dateFieldEnding.text = timeFormatter.stringFromDate(self.event.endTime)
            self.endDateLegit = self.event.endTime
            self.datePickerEndView.date = self.event.endTime
        }
        
        self.eventName.text = event.title
        self.eventDesc.text = event.description
    }
    
    @IBAction func dateFieldStart(sender: UITextField) {
        sender.inputView = self.datePickerStartView
    }
    
    func handleDatePickerStart(sender: UIDatePicker) {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .ShortStyle
        dateFieldStarting.text = timeFormatter.stringFromDate(sender.date)
        startDateLegit = sender.date
    }
    
    @IBAction func notifictionTimeOffsetPressed(sender: AnyObject) {
        let vc = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("NotificationTimeOffsetViewController") as! NotificationTimeOffsetViewController
        vc.delegate = self
        self.navigationController!.pushViewController(vc, animated: true)
    }

    @IBAction func dateFieldEnd(sender: UITextField) {
        sender.inputView = datePickerEndView

    }
    
    func handleDatePickerEnd(sender: UIDatePicker) {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .ShortStyle
        dateFieldEnding.text = timeFormatter.stringFromDate(sender.date)
        endDateLegit = sender.date
    }
    
    @IBAction func addEvent(sender: UIButton) {
        event.title = eventName.text!
        event.description = eventDesc.text!
        event.startTime = startDateLegit
        event.endTime = endDateLegit
        event.notificationTimeOffset = self.offsets[self.selectedOffsetIndex].1
        event.save()

        let index = self.navigationController!.viewControllers.count - 2
        if let vc = self.navigationController!.viewControllers[index] as? DayViewController {
            vc.reloadEvents()
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
