// Playground - noun: a place where people can play

import UIKit
import Foundation
import SQLite

let date = NSDate()

print(date)

let comps = NSCalendar.currentCalendar().components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)

print(comps)


NSUserDefaults.standardUserDefaults().setObject(5, forKey: "myName") // we are saving a variable called myName and we are giving it the value of "Bob"
NSUserDefaults.standardUserDefaults().synchronize() // Added synchronize as suggested by LAMMERT WESTERHOFF
println(NSUserDefaults.standardUserDefaults().objectForKey("myName")!) // Here we are accessing the variable.
 