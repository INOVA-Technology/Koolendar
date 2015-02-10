//
//  DayViewController.swift
//  Koolendar
//
//  Created by Addison Bean on 1/21/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import UIKit
import CoreData

class DayViewController: UIViewController {
    
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
        println("added event")
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext = appDel.managedObjectContext!
        
        var newEvent = NSEntityDescription.insertNewObjectForEntityForName("Events", inManagedObjectContext: context) as NSManagedObject
        
        newEvent.setValue("test event", forKey: "poop")
        newEvent.setValue("test event description", forKey: "test")
        
        context.save(nil)
        
        println(newEvent)
        println("its done been saved bruh")
        
    }
    
    @IBAction func whatFreakinEvents(sender: UIButton) {
        println("yo, user wants to know whats goin down today")
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Events")
        request.returnsObjectsAsFaults = false
        
        var results: NSArray = context.executeFetchRequest(request, error: nil)!
        
        if (results.count > 0) {
            for res in results {
                println(res)
            }
        }
        else {
            println("0 results... u got problems bro")
        }

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
