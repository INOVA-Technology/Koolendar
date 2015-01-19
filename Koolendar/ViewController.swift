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
    
    //add more clever way to do this
    var arr:[Int] = []
    
    var name: AnyObject? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("name")
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue!, forKey: "name")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
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
        
        //add more clever way to do this
        arr = [1, 2, 3]
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
        let date = NSDate()
        let day = calendar.components(.DayCalendarUnit, fromDate: date).day
        if indexPath.row == day - 1 {
            cell.backgroundColor = UIColor.blueColor()
        }
        return cell
    }

    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        name = arr[indexPath.row]
    }
}

