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
        
        let comps = NSDateComponents()
        comps.day = SelectedDate.day
        comps.month = SelectedDate.month
        comps.year = SelectedDate.year
        
        let cal = NSCalendar.currentCalendar()
        let date = cal.dateFromComponents(comps)!
        
        startTimeField.date = date
        endTimeField.date = date
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
        let em = EventManager.sharedInstance
        
        em.addEvent(title: eventName.text, notes: eventDesc.text, startDate: startTimeField.date, endDate: endTimeField.date)
        
//        self.navigationController?.presentViewController(MonthViewController(), animated: true, completion: nil)
        if let resultController = storyboard?.instantiateViewControllerWithIdentifier("DayView") as? DayViewController {
            presentViewController(resultController, animated: true, completion: nil)
        }
        
    }
    
}
