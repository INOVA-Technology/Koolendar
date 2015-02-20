// Playground - noun: a place where people can play

import UIKit
import SQLite
import Foundation

var str = "Hello, playground"

let languages:[String] = NSLocale.preferredLanguages() as [String]

let flags: NSCalendarUnit = .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit
let date = NSDate()
let cal = NSCalendar.currentCalendar()

let comps = cal.components(flags, fromDate: date)

let formatter = NSDateFormatter()
formatter.dateFormat = "MM"
let todayDate:Array = formatter.monthSymbols
todayDate[comps.month]


comps.month

cal.rangeOfUnit(.CalendarUnitDay, inUnit: .CalendarUnitMonth, forDate: date)

(1, 31)

let path = NSSearchPathForDirectoriesInDomains(
    .DocumentDirectory, .UserDomainMask, true
    ).first as String

// removes db:
//var fm = NSFileManager.defaultManager()
//var error: NSError?
//fm.removeItemAtPath("\(path)/KoolendarEventsList.sqlite3", error: &error)

let time = NSDate().timeIntervalSince1970
let data = NSDate(timeIntervalSince1970: time)




