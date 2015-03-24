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
let todayDate = formatter.monthSymbols
todayDate[comps.month]

let myWeekday = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday, fromDate: date).weekday


comps.month

comps.weekday

cal.rangeOfUnit(.CalendarUnitDay, inUnit: .CalendarUnitMonth, forDate: date)

(1, 31)

let path = NSSearchPathForDirectoriesInDomains(
    .DocumentDirectory, .UserDomainMask, true
    ).first as String

// removes db:
//var fm = NSFileManager.defaultManager()
//var error: NSError?
//fm.removeItemAtPath("\(path)/KoolendarEventsList.sqlite3", error: &error)
//

let calendarForMessingUp = NSCalendar.currentCalendar()

// Set up date object
let dateForMessingUp = NSDate()

let components = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMonth, fromDate: dateForMessingUp)

// Getting the First and Last date of the month
components.day = 1
components.year = 2015
let firstDateOfMonth: NSDate = calendarForMessingUp.dateFromComponents(components)!

components.month  += 1
components.day     = 0
let lastDateOfMonth: NSDate = calendarForMessingUp.dateFromComponents(components)!
var unitFlags = NSCalendarUnit.WeekOfMonthCalendarUnit |
    NSCalendarUnit.WeekdayCalendarUnit     |
    NSCalendarUnit.CalendarUnitDay

let firstDateComponents = calendarForMessingUp.components(unitFlags, fromDate: firstDateOfMonth)
let lastDateComponents  = calendarForMessingUp.components(unitFlags, fromDate: lastDateOfMonth)

firstDateComponents.weekday

