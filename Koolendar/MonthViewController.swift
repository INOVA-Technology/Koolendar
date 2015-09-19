//
//  MonthViewController.swift
//  Koolendar
//
//  Created by Addison Bean on 1/21/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import UIKit

class MonthViewController: CenterViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {
   
    @IBOutlet weak var nameOfMonth: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var daysOfTheWeekCollection: UICollectionView!
    @IBOutlet weak var daYearLabel: UILabel!
    
    let flags: NSCalendarUnit = [.Month, .Year]

    var calendar = NSCalendar.currentCalendar()
    
    var comps: NSDateComponents!
    let formatter = NSDateFormatter()
    
    var firstWeek:Int!
    var daysInMonth:Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = UIScreen.mainScreen().bounds
        let sizeX = screenSize.width
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.automaticallyAdjustsScrollViewInsets = false
        layout.itemSize = CGSize(width: sizeX/7, height: sizeX/7)
        collectionView.collectionViewLayout = layout
        collectionView.backgroundView = UIImageView(image: ColorScheme.background)
        
        self.formatter.dateFormat = "MM"
        
        setUpCalendarForCurrentDate()
        
        let layout2 = UICollectionViewFlowLayout()
        layout2.minimumInteritemSpacing = 0
        layout2.minimumLineSpacing = 0
        layout2.itemSize = CGSize(width: sizeX/7, height: sizeX/7)
        daysOfTheWeekCollection.collectionViewLayout = layout2
        daysOfTheWeekCollection.dataSource = self
        daysOfTheWeekCollection.delegate = self
        daysOfTheWeekCollection.allowsSelection = false
        daysOfTheWeekCollection.scrollEnabled = false
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleCellTap:")
        gestureRecognizer.delegate = self
        self.collectionView.addGestureRecognizer(gestureRecognizer)
    }
    
    func setUpCalendar(forMonth month: Int, year: Int) {
        self.comps = NSDateComponents()
        comps.month = month
        comps.year = year
        self.nameOfMonth.text = formatter.monthSymbols[comps.month - 1]
        self.daYearLabel.text = String(year)
        
        // Getting first day of month
        let calendarForMessingUp = NSCalendar.currentCalendar()
        let dateForMessingUp = calendarForMessingUp.dateFromComponents(self.comps)!
        
        let componentsForMessingUp = NSCalendar.currentCalendar().components([.Month], fromDate: dateForMessingUp)
        componentsForMessingUp.year = comps.year
        componentsForMessingUp.day = 1
        
        let firstDateOfMonth: NSDate = calendarForMessingUp.dateFromComponents(componentsForMessingUp)!
        componentsForMessingUp.month  += 1
        componentsForMessingUp.day     = 0
        
        let lastDateOfMonth = calendarForMessingUp.dateFromComponents(componentsForMessingUp)!
        let unitFlags: NSCalendarUnit = [.WeekOfMonth, .Weekday, .Day]
        
        let firstDateComponents = calendarForMessingUp.components(unitFlags, fromDate: firstDateOfMonth)
        let lastDateComponents  = calendarForMessingUp.components(unitFlags, fromDate: lastDateOfMonth)
        
        self.firstWeek = firstDateComponents.weekday
        self.daysInMonth = lastDateComponents.day
    }
    
    func setUpCalendarForCurrentDate() {
        let comps = NSCalendar.currentCalendar().components([.Month, .Year], fromDate: NSDate())
        setUpCalendar(forMonth: comps.month, year: comps.year)
    }
    
//    func setUpNavArrows() {
//        if let img = UIImage(named: "MonthSwitcherArrow") {
//            let imgView = UIImageView(image: img)
//            imgView.frame = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
//            imgView.tintColor = UIColor.redColor()
//            
//            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//            button.addTarget(self, action: "_goToNextMonth", forControlEvents: .TouchUpInside)
//            button.addSubview(imgView)
//            
//            button.translatesAutoresizingMaskIntoConstraints = false
//            var cs = [NSLayoutConstraint]()
//            cs.append(NSLayoutConstraint(item: button, attribute: .CenterX, relatedBy: .Equal, toItem: nameOfMonth, attribute: .CenterX, multiplier: 1, constant: 0))
//            cs.append(NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: nameOfMonth, attribute: .Right, multiplier: 1, constant: 8))
//            button.addConstraints(cs)
//            
//            view.addSubview(button)
//        } else {
//            print("ugh")
//        }
//    }
    
    func handleCellTap(recognizer: UITapGestureRecognizer) {
        let point = recognizer.locationInView(self.collectionView)
        
        guard let indexPath = self.collectionView.indexPathForItemAtPoint(point) else { return }

        let comps = NSDateComponents()
        comps.day = indexPath.row - firstWeek + 2
        comps.month = self.comps.month
        comps.year = self.comps.year
        
        let vc = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("DayViewController") as! DayViewController
        vc.dateComps = comps
        self.navigationController!.pushViewController(vc, animated: true)
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
        print("double tapped a date!")
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return 42
        } else {
            return 7
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! MonthViewCell
            let todaysComps = calendar.components([.Day, .Month, .Year], fromDate: NSDate())
            
            if (indexPath.row % 2 == 0) {
                cell.backgroundColor = ColorScheme.dayCellEven
                cell.theDay.textColor = UIColor.whiteColor()
            } else {
                cell.backgroundColor = ColorScheme.dayCellOdd
                cell.theDay.textColor = UIColor.blackColor()
            }
            if (indexPath.row - firstWeek + 1 == todaysComps.day - 1 && comps.month == todaysComps.month && comps.year == todaysComps.year) {
                cell.backgroundColor = ColorScheme.currentDayCell
                cell.theDay.textColor = UIColor.whiteColor()
            }
            if (indexPath.row >= firstWeek - 1 && indexPath.row + 1 < daysInMonth + firstWeek) {
                
                let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
                
                let components = NSDateComponents()
                components.year = self.comps.year
                components.month = self.comps.month
                components.day = indexPath.row - firstWeek + 2
//                components.hour = 14
//                components.minute = 20
//                components.second = 0
                
                let hotDate = calendar!.dateFromComponents(components)
                
                if (Event.eventsOnDate(hotDate!).count > 0) {
                    cell.theDay.text = String(indexPath.row - firstWeek + 2)
                    cell.hasDates.hidden = false
                }
                else {
                    cell.hasDates.hidden = true
                    cell.theDay.text = String(indexPath.row - firstWeek + 2)
                }
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

    @IBAction func showSidebar(sender: AnyObject) {
        self.delegate?.toggleLeftPanel?()
    }
    
    @IBAction func goToNextMonth(sender: AnyObject) {
        if self.comps.month == 12 {
            self.comps.month = 0
            self.comps.year++
        }
        setUpCalendar(forMonth: self.comps.month + 1, year: self.comps.year)
        self.collectionView.reloadData()
    }

    
    @IBAction func goToPreviousMonth(sender: AnyObject) {
        if self.comps.month == 1 {
            self.comps.month = 13
            self.comps.year--
        }
        setUpCalendar(forMonth: self.comps.month - 1, year: self.comps.year)
        self.collectionView.reloadData()
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
