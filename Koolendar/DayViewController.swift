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

class DayViewController: UIViewController {
    
    @IBOutlet weak var theEventsOfLife: UILabel!
    @IBOutlet weak var dude: UIImageView!
    //    @IBOutlet weak var eventsOfLife: UILabel!
    
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
    
    @IBAction func addEvent(sender: UIButton) {
        //        println("added event")
        //
        //
        //
        //        println("its done been saved bruh")
        
    }
    
    @IBAction func whatFreakinEvents(sender: UIButton) {
        
        
        println("yo, user wants to know whats goin down today")
        
        //        dude.hidden = true
        //        eventsOfLife.hidden = false
        
        
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true
            ).first as String
        
        let db = Database("\(path)/KoolendarEventsList.sqlite3")
        let events = db["events"]
        let name = Expression<String>("name")
        let desc = Expression<String>("desc")
        
        var testing: String = ""
        for user in events {
            testing = "\(testing)event name: \(user[name]) event desc: \(user[desc])"
            // id: 1, name: Optional("Alice"), email: alice@mac.com
        }
        theEventsOfLife.text = testing
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
