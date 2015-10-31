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
    @IBOutlet weak var koolTableView: UITableView!
    
    var collectionViewHeightConstraint: NSLayoutConstraint!
    
    let flags: NSCalendarUnit = [.Month, .Year]

    var calendar = NSCalendar.currentCalendar()
    
    var comps: NSDateComponents!
    let formatter = NSDateFormatter()
    
    var firstWeek:Int!
    var daysInMonth:Int!
    
    var selectedDay: Int!
    var eventsOnSelectedDay: [Event]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let bgImageView = UIImageView(image: UIImage(named: "SimpleBg"))
        bgImageView.contentMode = .ScaleAspectFill
        self.view.addSubview(bgImageView)
        self.view.sendSubviewToBack(bgImageView)
        
        let screenSize = UIScreen.mainScreen().bounds
        let sizeX = screenSize.width
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.automaticallyAdjustsScrollViewInsets = false
        layout.itemSize = CGSize(width: sizeX/7, height: sizeX/7)
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = UIColor.clearColor()
        
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
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.koolTableView.delegate = self
        self.koolTableView.dataSource = self
        
        self.koolTableView.backgroundColor = UIColor.clearColor()
        
        let day = NSCalendar.currentCalendar().component(.Day, fromDate: NSDate())
        self.selectedDay = day
        
        let comps = NSCalendar.currentCalendar().components([.Month, .Year], fromDate: NSDate())
        comps.day = selectedDay
        self.eventsOnSelectedDay = Event.eventsOnDate(NSCalendar.currentCalendar().dateFromComponents(comps)!)
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
        
        self.collectionView.reloadData()
        self.koolTableView.reloadData()
        setUpConstraints()
    }
    
    func setUpCalendarForCurrentDate() {
        let comps = NSCalendar.currentCalendar().components([.Month, .Year], fromDate: NSDate())
        setUpCalendar(forMonth: comps.month, year: comps.year)
    }
    
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
    
    override func viewWillAppear(animated: Bool) {
        let comps = NSCalendar.currentCalendar().components([.Month, .Year], fromDate: NSDate())
        comps.day = selectedDay
        self.eventsOnSelectedDay = Event.eventsOnDate(NSCalendar.currentCalendar().dateFromComponents(comps)!)
        
        self.collectionView.reloadData()
        self.koolTableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        setUpConstraints()
    }
    
    func setUpConstraints() {
        let x = self.collectionView.collectionViewLayout.collectionViewContentSize().height
        if collectionViewHeightConstraint == nil {
            collectionViewHeightConstraint = NSLayoutConstraint(item: self.collectionView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: x)
            self.collectionView.addConstraint(collectionViewHeightConstraint)
        } else {
            collectionViewHeightConstraint.constant = x
        }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        let screenSize = UIScreen.mainScreen().bounds
        let sizeX = screenSize.width
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: sizeX / 7, height: sizeX / 7)
        
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
            return Int(ceil(Double(daysInMonth + firstWeek - 1) / 7) * 7)
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
//                components.hour = 4
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
            
            let days = ["S", "M", "T", "W", "T", "F", "S"]
            
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
    }

    
    @IBAction func goToPreviousMonth(sender: AnyObject) {
        if self.comps.month == 1 {
            self.comps.month = 13
            self.comps.year--
        }
        setUpCalendar(forMonth: self.comps.month - 1, year: self.comps.year)
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

extension MonthViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = koolTableView.dequeueReusableCellWithIdentifier("daySummaryCell", forIndexPath: indexPath) as! DaySummaryCell
        cell.backgroundColor = UIColor.clearColor()
        cell.eventName.text = eventsOnSelectedDay[indexPath.row].title
//        cell.eventTime.text = "placeholder"
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return eventsOnSelectedDay.count
        } else {
            // this'll be for the remindersu
            return 0
        }
    }
    
}





