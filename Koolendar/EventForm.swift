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
    
    
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventDesc: UITextField!
    
    @IBOutlet weak var startTimeField: UIDatePicker!
    @IBOutlet weak var endTimeField: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
    
    @IBAction func addEvent(sender: UIButton) {
        let em = EventManager()
        
        let units: NSCalendarUnit = .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute
        
        let cal = NSCalendar.currentCalendar()
        
        let startTime = cal.components(units, fromDate: startTimeField.date)
        let endTime   = cal.components(units, fromDate:   endTimeField.date)
        
        println("life:\(startTime.minute)")

        
        let date = NSDateComponents()
        date.day = SelectedDate.day
        date.month = SelectedDate.month
        date.year = SelectedDate.year
        
        em.addEvent(name: eventName.text, description: eventDesc.text, date: date, startTime: startTime, endTime: endTime, allDay: false)
        
        self.navigationController?.popViewControllerAnimated(true)

        
    }
    
}
