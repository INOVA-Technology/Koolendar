// Playground - noun: a place where people can play

import UIKit
// import SQLite
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

//let db = Database("\(path)/KoolendarEventsList.sqlite3")
//
//let id   = Expression<Int>("id")
//let name = Expression<String>("name")
//
//let desc = Expression<String>("desc")
//let allDay = Expression<Bool>("allDay")
//
//let startHour = Expression<Int>("startHour")
//let endHour   = Expression<Int>("endHour")
//let startMinute = Expression<Int>("startMinute")
//let endMinute   = Expression<Int>("endMinute")
//
//let day = Expression<Int>("day")
//let month = Expression<Int>("month")
//let year = Expression<Int>("year")
//
//let events = db["events"]
//
//db.create(table: events, ifNotExists: true) { t in
//    t.column(id)
//    t.column(name)
//    t.column(desc)
//    t.column(allDay)
//    t.column(startHour)
//    t.column(endHour)
//    t.column(startMinute)
//    t.column(endMinute)
//    t.column(day)
//    t.column(month)
//    t.column(year)
//}

//events.insert(id <- events.count, name <- "Event Name")

