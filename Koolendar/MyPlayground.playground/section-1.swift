// Playground - noun: a place where people can play

import UIKit
import SQLite

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

let db = Database("\(path)/KoolendarEventsList.sqlite3")
let events = db["events"]
let id   = Expression<Int>("id")
let name = Expression<String>("name")
let desc = Expression<String>("desc")

db.create(table: events, ifNotExists: true) { t in
    t.column(id)
    t.column(name)
    t.column(desc)
}

if let insertId = events.insert(name <- "Konnichiwa", desc <- "BLJAKAHA", id <- events.count) {
    //            println(events.filter(name == eventName.text))
}

events.count

