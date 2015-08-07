//
//  MonthViewController.swift
//  Koolendar
//
//  Created by Addison Bean on 1/21/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import UIKit

// TODO: make this an NSDateComponets
struct SelectedDate {
    static var day: Int!
    static var month: Int!
    static var year: Int!
}

class MonthViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: variables and constants
    
    @IBOutlet weak var nameOfMonth: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var daysOfTheWeekCollection: UICollectionView!
    
    let flags: NSCalendarUnit = .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit

    var calendar = NSCalendar.currentCalendar()
    var date = NSDate()
    
    var comps: NSDateComponents!
    let formatter = NSDateFormatter()
    
    var firstWeek:Int!
    var daysInMonth:Int!
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
        layout.itemSize = CGSize(width: sizeX/7, height: sizeX/7)
        collectionView.collectionViewLayout = layout
//        collectionView.backgroundView = UIImageView(image: UIImage(named: "SimpleBg"))
        collectionView.backgroundColor = ColorScheme.background
        comps = calendar.components(flags, fromDate: date)
        formatter.dateFormat = "MM"
        
        let todayDate:Array = formatter.monthSymbols
        nameOfMonth.text = String(todayDate[comps.month - 1] as! NSString)
        
        // Getting first day of month
        let calendarForMessingUp = NSCalendar.currentCalendar()
        let dateForMessingUp = NSDate()
        let componentsForMessingUp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMonth, fromDate: dateForMessingUp)
        
        componentsForMessingUp.year = comps.year
        componentsForMessingUp.day = 1
        let firstDateOfMonth: NSDate = calendarForMessingUp.dateFromComponents(componentsForMessingUp)!
        componentsForMessingUp.month  += 1
        componentsForMessingUp.day     = 0
        let lastDateOfMonth: NSDate = calendarForMessingUp.dateFromComponents(componentsForMessingUp)!
        var unitFlags = NSCalendarUnit.WeekOfMonthCalendarUnit |
            NSCalendarUnit.WeekdayCalendarUnit     |
            NSCalendarUnit.CalendarUnitDay
        
        let firstDateComponents = calendarForMessingUp.components(unitFlags, fromDate: firstDateOfMonth)
        let lastDateComponents  = calendarForMessingUp.components(unitFlags, fromDate: lastDateOfMonth)
        firstWeek = firstDateComponents.weekday
        daysInMonth = lastDateComponents.day
        
        let layout2 = UICollectionViewFlowLayout()
        layout2.minimumInteritemSpacing = 0
        layout2.minimumLineSpacing = 0
        // ugh, we can't hard code 30 in, but I don't feel like doing it another way right now
        layout2.itemSize = CGSize(width: sizeX/7, height: 30)
        daysOfTheWeekCollection.collectionViewLayout = layout2
        daysOfTheWeekCollection.dataSource = self
        daysOfTheWeekCollection.delegate = self
        daysOfTheWeekCollection.allowsSelection = false
        daysOfTheWeekCollection.scrollEnabled = false
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        let screenSize = UIScreen.mainScreen().bounds
        let sizeX = screenSize.width
        let sizeY = screenSize.height
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: sizeX / 7, height: sizeY / 7)
        
        let layout2 = daysOfTheWeekCollection.collectionViewLayout as! UICollectionViewFlowLayout
        layout2.itemSize = CGSize(width: 30, height: sizeX/7)
        
        layout.invalidateLayout()
        layout2.invalidateLayout()
    }
    
    // MARK: Collection Cell Stuff
    
    // its not letting me connect this from the cell's gesture recognizer to this controller in the storyboard
    @IBAction func previewDate(recognizer: UITapGestureRecognizer) {
        println("double tapped a date!")
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let myWeekday = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday, fromDate: date).weekday
        
//        return calendar.rangeOfUnit(.CalendarUnitDay, inUnit: .CalendarUnitMonth, forDate: date).length + firstWeek - 1
        if collectionView == self.collectionView {
            return 35
        } else {
            return 7
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if collectionView == self.collectionView {
            // TODO: show new DayViewController in here, instead of in the storyboard
            SelectedDate.day = indexPath.row - firstWeek + 2
            SelectedDate.month = comps.month
            SelectedDate.year = comps.year
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! MonthViewCell
            let myWeekday = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday, fromDate: date).weekday
            let day = calendar.components(.DayCalendarUnit, fromDate: date).day
            
            if (indexPath.row % 2 == 0) {
                cell.backgroundColor = ColorScheme.dayCell
                cell.theDay.textColor = UIColor.whiteColor()
            } else {
                cell.backgroundColor = ColorScheme.dayCell2
                cell.theDay.textColor = UIColor.blackColor()
            }
            if (indexPath.row - firstWeek + 1 == comps.day - 1) {
                cell.backgroundColor = ColorScheme.currentDayCell
                cell.theDay.textColor = UIColor.whiteColor()
            }
            if (indexPath.row >= firstWeek - 1 && indexPath.row + 1 < daysInMonth + firstWeek) {
                cell.theDay.text = String(indexPath.row - firstWeek + 2)
    //            cell.theDay.text = String(indexPath.row)
            } else {
                cell.theDay.text = ""
            }
            
            return cell
        } else {
            let cell = daysOfTheWeekCollection.dequeueReusableCellWithReuseIdentifier("dayOfTheWeekCell", forIndexPath: indexPath) as! DayOfTheWeekCell
            
            let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
            
            cell.dayName.text = days[indexPath.row]
//            
            return cell
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
