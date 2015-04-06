//
//  EventForm.swift
//  Koolendar
//
//  Created by Chase on 2/10/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import UIKit
import SQLite

class EventForm: UIViewController {
    
    @IBOutlet weak var dateFieldStarting: UITextField!
    @IBOutlet weak var dateFieldEnding: UITextField!
    
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventDesc: UITextField!
    
    var startDateLegit: NSDate!
    var endDateLegit:NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let comps = NSDateComponents()
        comps.day = SelectedDate.day
        comps.month = SelectedDate.month
        comps.year = SelectedDate.year
        
        let cal = NSCalendar.currentCalendar()
        let date = cal.dateFromComponents(comps)!
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
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    @IBAction func dateFieldStart(sender: UITextField) {
        
        var datePickerStartView  : UIDatePicker = UIDatePicker()
        datePickerStartView.datePickerMode = UIDatePickerMode.Time
        sender.inputView = datePickerStartView
        
        datePickerStartView.addTarget(self, action: Selector("handleDatePickerStart:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func handleDatePickerStart(sender: UIDatePicker) {
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .ShortStyle
        dateFieldStarting.text = timeFormatter.stringFromDate(sender.date)
        startDateLegit = sender.date
    }
    
    // Oh shut up... u know its not efficient. i couldnt think of a simpler way to.
    @IBAction func dateFieldEnd(sender: UITextField) {
        
        var datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Time
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: Selector("handleDatePickerEnd:"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    func handleDatePickerEnd(sender: UIDatePicker) {
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .ShortStyle
        dateFieldEnding.text = timeFormatter.stringFromDate(sender.date)
        endDateLegit = sender.date
    }
    
    @IBAction func addEvent(sender: UIButton) {
        let em = EventManager.sharedInstance
        
        em.addEvent(title: eventName.text, notes: eventDesc.text, startDate: startDateLegit, endDate: endDateLegit)
        navigationController?.popViewControllerAnimated(true)
        
//        self.navigationController?.presentViewController(DayViewController(), animated: true, completion: nil)
        
//        if let resultController = storyboard?.instantiateViewControllerWithIdentifier("DayView") as? DayViewController {
//            presentViewController(resultController, animated: true, completion: nil)
//        }
        
    }
    
}
