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

let db = Database("\(path)/KoolendarEventsList.sqlite3")
let id   = Expression<Int>("id")
let startDate = Expression<Double>("startDate")
let endDate = Expression<Double>("endDate")
let name = Expression<String>("name")
let desc = Expression<String>("desc")
let events = db["events"]

db.create(table: events, ifNotExists: true) { t in
    t.column(id)
    t.column(name)
    t.column(desc)
    t.column(startDate)
    t.column(endDate)
}

//events.insert(id <- events.count, name <- "Event Name")

