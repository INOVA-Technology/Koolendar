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
        println(startTimeField)
        let em = EventManager()
        em.addEvent(name: eventName.text, description: eventDesc.text, startDate: startTimeField.date, endDate: endTimeField.date, allDay: false)
        
        println("its done been saved bruh")
        
    }
    
}
