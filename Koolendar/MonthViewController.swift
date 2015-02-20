//
//  MonthViewController.swift
//  Koolendar
//
//  Created by Addison Bean on 1/21/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import UIKit

class MonthViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var nameOfMonth: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    let flags: NSCalendarUnit = .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit

    var calendar = NSCalendar.currentCalendar()
    var date = NSDate()
    
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
//        collectionView.backgroundColor = ColorScheme.background
        collectionView.backgroundView = UIImageView(image: UIImage(named: "SimpleBg"))
        var comps = calendar.components(flags, fromDate: date)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM"
        let todayDate:Array = formatter.monthSymbols
        nameOfMonth.text = String(todayDate[comps.month - 1] as NSString)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendar.rangeOfUnit(.CalendarUnitDay, inUnit: .CalendarUnitMonth, forDate: date).length
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let dayViewController = DayViewController()
        var comps = calendar.components(flags, fromDate: date)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM"
        let todayDate:Array = formatter.monthSymbols
        
        dayViewController.currentDay = indexPath.row - 1
        dayViewController.currentMonth = todayDate[comps.month - 1] as String
        dayViewController.currentYear = comps.year
        
        println("day: \(indexPath.row - 1)")
        println("month: \(todayDate[comps.month - 1])")
        println("year: \(comps.year)")
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as MonthViewCell
        cell.theDay.text = String(indexPath.row + 1)
        let day = calendar.components(.DayCalendarUnit, fromDate: date).day
        
        if (indexPath.row % 2 == 0 && indexPath.row != day - 1) {
            cell.backgroundColor = UIColor.clearColor()
        } else if (indexPath.row == day - 1) {
            cell.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            cell.theDay.textColor = UIColor.whiteColor()
        } else {
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
            
            
            
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
