// Playground - noun: a place where people can play

import UIKit
import Foundation
import SQLite

let date = NSDate()

print(date)

let comps = NSCalendar.currentCalendar().components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)

print(comps)
