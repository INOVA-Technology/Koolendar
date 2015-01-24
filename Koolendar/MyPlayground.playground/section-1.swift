// Playground - noun: a place where people can play

import UIKit

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

var info: NSDictionary?
if let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist") {
    info = NSDictionary(contentsOfFile: path)
}
if let dict = info {
    info!["LSRequiresIPhoneOS"]
}
