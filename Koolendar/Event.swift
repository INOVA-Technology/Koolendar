//
//  Event.swift
//  Koolendar
//
//  Created by Addison Bean on 5/21/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import Foundation
import SQLite

extension NSDate: Value {
    public class var declaredDatatype: String {
        return String.declaredDatatype
    }
    public class func fromDatatypeValue(stringValue: String) -> NSDate {
        return SQLDateFormatter.dateFromString(stringValue)!
    }
    public var datatypeValue: String {
        return SQLDateFormatter.stringFromDate(self)
    }
}

let SQLDateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    return formatter
}()

class Event {
    
    var title: String
    var startTime: NSDate
    var endTime: NSDate
    
    var allDay: Bool {
        get {
            let cal = NSCalendar.currentCalendar()
            let units: NSCalendarUnit = .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute
            let startComps = cal.components(units, fromDate: startTime)
            let endComps   = cal.components(units, fromDate: endTime)
            
            return startComps.hour == 0 && startComps.minute == 0 && startComps.day + 1 == endComps.day
        }
        // TODO: add `set { ... }`
    }

    init(title: String, startTime: NSDate, endTime: NSDate) {
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
    }
    
    func save() {
        let id_e = Expression<Int>("id")
        let title_e = Expression<String>("title")
        let startTime_e = Expression<NSDate>("startTime")
        let endTime_e = Expression<NSDate>("endTime")
        
        let dbDir = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true).first as! String
        let db = Database("\(dbDir)/KoolendarDB.sqlite3")
        
        let events = db["events"]
        
        db.create(table: events, ifNotExists: true) { t in
            t.column(id_e, primaryKey: true)
            t.column(title_e)
            t.column(startTime_e)
            t.column(endTime_e)
        }
        
        events.insert(title_e <- self.title, startTime_e <- self.startTime, endTime_e <- self.endTime)
    }
    
    class func eventsOnDate(date: NSDate) {
        let id_e = Expression<Int>("id")
        let title_e = Expression<String>("title")
        let startTime_e = Expression<NSDate>("startTime")
        let endTime_e = Expression<NSDate>("endTime")
        
        let dbDir = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true).first as! String
        let db = Database("\(dbDir)/KoolendarDB.sqlite3")
        
        let events = db["events"]
        
        db.create(table: events, ifNotExists: true) { t in
            t.column(id_e, primaryKey: true)
            t.column(title_e)
            t.column(startTime_e)
            t.column(endTime_e)
        }
        
        let units: NSCalendarUnit = .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond
        let comps = NSCalendar.currentCalendar().components(units, fromDate: date)
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        let startOfDay = NSCalendar.currentCalendar().dateFromComponents(comps)!
        
        let results = events.filter(startTime_e <= startOfDay).order(startTime_e)
        
        if let event = results.first {
            println(event[events[title_e]])
        }
    }
    
}
