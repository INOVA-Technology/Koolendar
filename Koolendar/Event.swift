//
//  Event.swift
//  Koolendar
//
//  Created by Addison Bean on 5/21/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import Foundation
import SQLite

private let id_e = Expression<Int>("id")
private let title_e = Expression<String>("title")
private let startTime_e = Expression<NSDate>("startTime")
private let endTime_e = Expression<NSDate>("endTime")
private let description_e = Expression<String>("description")

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
    var description: String
    var startTime: NSDate
    var endTime: NSDate
    
    var id: Int?
    
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
    
    // in seconds
    var notificationTimeOffset: NSTimeInterval
    var notificationTime: NSDate {
        return self.startTime.dateByAddingTimeInterval(-notificationTimeOffset)
    }

    init(title: String, description: String, startTime: NSDate, endTime: NSDate, notificationTimeOffset: NSTimeInterval, id: Int?) {
        self.title = title
        self.description = description
        self.startTime = startTime
        self.endTime = endTime
        self.notificationTimeOffset = notificationTimeOffset
        self.id = id
    }
    
    convenience init(title: String, description: String, startTime: NSDate, endTime: NSDate) {
        self.init(title: title, description: description, startTime: startTime, endTime: endTime, notificationTimeOffset: 0, id: nil)
    }
    
    convenience init(row: Row) {
        self.init(title: row.get(title_e), description: row.get(description_e), startTime: row.get(startTime_e), endTime: row.get(endTime_e), notificationTimeOffset: 0, id: row.get(id_e))
    }
    
    func save() {
        Event.events() { events in
            if let id = self.id {
                events.filter(id_e == id).update(title_e <- self.title, description_e <- self.description, startTime_e <- self.startTime, endTime_e <- self.endTime)
            } else if let id = events.insert(title_e <- self.title, description_e <- self.description, startTime_e <- self.startTime, endTime_e <- self.endTime).rowid {
                self.id = Int(id)
            } else {
                println("couldn't save the event 😞")
            }
        }
        
    }
    
    class private func events(block: (Query -> Void)) {
        let dbDir = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true).first as! String
        let db = Database("\(dbDir)/KoolendarDB.sqlite3")
        
        let events = db["events"]
        
        db.create(table: events, ifNotExists: true) { t in
            t.column(id_e, primaryKey: true)
            t.column(title_e)
            t.column(description_e)
            t.column(startTime_e)
            t.column(endTime_e)
        }
        
        block(events)
    }
    
    class func eventsOnDate(date: NSDate) -> [Event] {
        var evvents = [Event]()
        
        Event.events() { events in
        
            let units: NSCalendarUnit = .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond
            let comps = NSCalendar.currentCalendar().components(units, fromDate: date)
            comps.hour = 0
            comps.minute = 0
            comps.second = 0
            let startOfDay = NSCalendar.currentCalendar().dateFromComponents(comps)!
            comps.day += 1
            let endOfDay = NSCalendar.currentCalendar().dateFromComponents(comps)!
            
            let results = events.filter(startTime_e >= startOfDay).filter(endTime_e <= endOfDay).order(startTime_e)
            
            for res in results {
                evvents.append(Event(row: res))
            }
        }
        
        return evvents
    }
    
    class func each(block: (Event -> ())) { 
        Event.events() { events in
            for e in events {
                block(Event(row: e))
            }
        }

    }
    
}
