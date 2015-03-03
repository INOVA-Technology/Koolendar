//
//  MonthViewController.swift
//  Koolendar
//
//  Created by Addison Bean on 1/21/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import UIKit

struct SelectedDate {
    static var day: Int!
    static var month: Int!
    static var year: Int!
}

class MonthViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: variables and constants
    
    @IBOutlet weak var nameOfMonth: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let flags: NSCalendarUnit = .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit

    var calendar = NSCalendar.currentCalendar()
    var date = NSDate()
    
    var comps: NSDateComponents!
    let formatter = NSDateFormatter()
    
    // MARK: da functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = UIScreen.mainScreen().bounds
        let sizeX = screenSize.width
        let sizeY = screenSize.height
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.automaticallyAdjustsScrollViewInsets = false
        layout.itemSize = CGSize(width: sizeX/3, height: sizeY/5)
        collectionView.collectionViewLayout = layout
        collectionView.backgroundView = UIImageView(image: UIImage(named: "SimpleBg"))
        
        comps = calendar.components(flags, fromDate: date)
        formatter.dateFormat = "MM"
        
        let todayDate:Array = formatter.monthSymbols
        nameOfMonth.text = String(todayDate[comps.month - 1] as NSString)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "scheduleNotifications", name: "scheduleNotifications", object: nil)
    }
    
    func scheduleNotifications() {
        // TODO: get notifications working
        let em = EventManager()
        for event in em.allEvents {
            let notification = UILocalNotification()
            
            notification.alertBody = event.name
            notification.fireDate = event.startDate
            notification.timeZone = NSTimeZone.defaultTimeZone()
            notification.soundName = UILocalNotificationDefaultSoundName
            
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
    
    // MARK: Collection Cell Stuff
    
    // its not letting me connect this from the cell's gesture recognizer to this controller in the storyboard
    @IBAction func previewDate(recognizer: UITapGestureRecognizer) {
        println("double tapped a date!")
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendar.rangeOfUnit(.CalendarUnitDay, inUnit: .CalendarUnitMonth, forDate: date).length
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // TODO: show new DayViewController in here, instead of in the storyboard
        SelectedDate.day = indexPath.row + 1
        SelectedDate.month = comps.month
        SelectedDate.year = comps.year
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as MonthViewCell
        cell.theDay.text = String(indexPath.row + 1)
        let day = calendar.components(.DayCalendarUnit, fromDate: date).day
        
        if (indexPath.row % 2 == 0 && indexPath.row != day - 1) {
            cell.backgroundColor = UIColor.clearColor()
            cell.theDay.textColor = UIColor.blackColor()
        } else if (indexPath.row == comps.day - 1) {
            cell.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            cell.theDay.textColor = UIColor.whiteColor()
        } else {
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
            cell.theDay.textColor = UIColor.blackColor()            
            
            
        }
        
        return cell
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
