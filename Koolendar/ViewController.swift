//
//  ViewController.swift
//  Koolendar
//
//  Created by Chase on 1/19/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var collectionView: UICollectionView?
    var calendar = NSCalendar.currentCalendar()
    var date = NSDate()
    
    //add more clever way to do this
    var arr:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        This isn't working :(
//        let screenSize = UIScreen.mainScreen().bounds
//        let sizeX = screenSize.width
//        let sizeY = screenSize.height
//        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.itemSize = CGSize(width: sizeX/3, height: sizeY/3)
//        collectionView?.collectionViewLayout = layout
//        collectionView?.backgroundColor = UIColor.orangeColor()
        
        let daysInMonth = calendar.rangeOfUnit(.CalendarUnitDay, inUnit: .CalendarUnitMonth, forDate: date).length
        
        arr = [Int](1...daysInMonth)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as CollectionViewCell
        cell.theDay.text = String(arr[indexPath.row])
        let day = calendar.components(.DayCalendarUnit, fromDate: date).day
        if indexPath.row == day - 1 {
            cell.backgroundColor = UIColor.blueColor()
        }
        return cell
    }

}

