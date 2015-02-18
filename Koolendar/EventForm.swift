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
        println("added event")
        // possibly copied and pasted some of this... don't judge.
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true
            ).first as String
        
        let db = Database("\(path)/KoolendarEventsList.sqlite3")  // name is long so it has a very slim chance of being accessed by other apps
        
        let events = db["events"]
        let name = Expression<String>("name")
        let desc = Expression<String>("desc")
        
        db.create(table: events, ifNotExists: true) { t in
            t.column(name)
            t.column(desc)
        }
        
        if let insertId = events.insert(name <- eventName.text, desc <- eventDesc.text) {
            //            println(events.filter(name == eventName.text))
        }
        
        for user in events {
            println("name: \(user[name])")
            // id: 1, name: Optional("Alice"), email: alice@mac.com
        }
        //        println(newEvent)
        println("its done been saved bruh")
        
    }
    
}
