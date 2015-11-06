//
//  ReminderForm.swift
//  Koolendar
//
//  Created by Addison Bean on 11/2/15.
//  Copyright © 2015 INOVA. All rights reserved.
//

import UIKit

class ReminderForm: UIViewController {
    
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var reminderName: UITextField!
    
    var datePicker = UIDatePicker()
    
    var reminder: Reminder!
    
    var daDate: NSDate!
    
    override func viewDidLoad() {
        datePicker.timeZone = NSCalendar.currentCalendar().timeZone
        datePicker.calendar = NSCalendar.currentCalendar()
        datePicker.datePickerMode = .Time
        datePicker.addTarget(self, action: "handleDatePicker", forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    @IBAction func datePickerAction(sender: UITextField) {
        sender.inputView = datePicker
    }
    
    @IBAction func createReminder() {
        reminder.title = reminderName.text!
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let f = NSDateFormatter()
        f.dateStyle = .NoStyle
        f.timeStyle = .ShortStyle
        dateField.text = f.stringFromDate(sender.date)
        daDate = sender.date
    }
    
}
