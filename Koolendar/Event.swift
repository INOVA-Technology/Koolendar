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
private let notificationTimeOffset_e = Expression<Int>("notificationTimeOffset")

extension NSDate {
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
    
    private var _title: String?
    var title: String {
        set {
            _title = newValue
        }
        get {
            if let title = self._title {
                return title
            } else {
                self._title = self.sqlRow!.get(title_e)
                return self._title!
            }
        }
    }
    
    private var _description: String?
    var description: String {
        set {
            _description = newValue
        }
        get {
            if let description = self._description {
                return description
            } else {
                self._description = self.sqlRow!.get(description_e)
                return self._description!
            }
        }
    }
    
    private var _startTime: NSDate?
    var startTime: NSDate {
        set {
            _startTime = newValue
        }
        get {
            if let startTime = self._startTime {
                return startTime
            } else {
                self._startTime = self.sqlRow!.get(startTime_e)
                return self._startTime!
            }
        }
    }
    
    private var _endTime: NSDate?
    var endTime: NSDate {
        set {
            _endTime = newValue
        }
        get {
            if let endTime = self._endTime {
                return endTime
            } else {
                self._endTime = self.sqlRow!.get(endTime_e)
                return self._endTime!
            }
        }
    }
    
    var _id: Int?
    var id: Int? {
        set {
            _id = newValue
        }
        get {
            if let id = self._id {
                return id
            } else if let row = self.sqlRow {
                self._id = row.get(id_e)
                return self._id
            } else {
                return nil
            }
        }
    }
    
    var sqlRow: Row?
    
    var allDay: Bool {
        get {
            let cal = NSCalendar.currentCalendar()
            let units: NSCalendarUnit = [.Day, .Hour, .Minute]
            let startComps = cal.components(units, fromDate: startTime)
            let endComps   = cal.components(units, fromDate: endTime)
            
            return startComps.hour == 0 && startComps.minute == 0 && startComps.day + 1 == endComps.day
        }
        // TODO: add `set { ... }`
    }
    
    // in seconds
    var _notificationTimeOffset: NSTimeInterval?
    var notificationTimeOffset: NSTimeInterval {
        set {
            _notificationTimeOffset = newValue
        }
        get {
            self._notificationTimeOffset = NSTimeInterval(self.sqlRow!.get(notificationTimeOffset_e))
            return self._notificationTimeOffset!
        }
    }
    var notificationTime: NSDate {
        return self.startTime.dateByAddingTimeInterval(-notificationTimeOffset)
    }

    init(title: String, description: String, startTime: NSDate, endTime: NSDate, notificationTimeOffset: NSTimeInterval, id: Int?) {
        self.notificationTimeOffset = notificationTimeOffset
        self.title = title
        self.description = description
        self.startTime = startTime
        self.endTime = endTime
        self.id = id
    }
    
    init(row: Row) {
        self.notificationTimeOffset = 0 // we gotta store this in the db...
        self.sqlRow = row
    }
    
    convenience init(day: Int, month: Int, year: Int) {
        let comps = NSCalendar.currentCalendar().components([.Minute, .Hour], fromDate: NSDate())
        comps.day = day
        comps.month = month
        comps.year = year
        let date = NSCalendar.currentCalendar().dateFromComponents(comps)!
        self.init(title: "", description: "", startTime: date, endTime: date, notificationTimeOffset: 0, id: nil)
    }
    
    func save() {
        Event.events() { events, db in
            if let id = self.id {
                let _ = try? db.run(events.filter(id_e == id).update(title_e <- self.title, description_e <- self.description, startTime_e <- self.startTime, endTime_e <- self.endTime))
            } else {
                do {
//                    let id = try db.run(events.insert(title_e <- self.title, description_e <- self.description, startTime_e <- self.startTime, endTime_e <- self.endTime))
                    let id = try db.run(events.insert(title_e <- self.title, description_e <- self.description, startTime_e <- self.startTime, endTime_e <- self.endTime, notificationTimeOffset_e <- 0))
                    self.id = Int(id)
                } catch {
                    print("couldn't save the event 😞")
                    print(error)
                }
            }
        }
        
    }
    
    func delete() {
        guard let id = self.id else {
            print("couldn't delete an event that hasn't been saved")
            return
        }
        
        Event.events() { events, db in
            let _ = try? db.run(events.filter(id_e == id).delete())
        }
    }
    
    class private func events(block: ((QueryType, Connection) -> Void)) {
        let dbDir = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true).first!
        let db = try! Connection("\(dbDir)/KoolendarDB.sqlite3")
        
        let events = Table("events")
        
        try! db.run(events.create(ifNotExists: true) { t in
            t.column(id_e, primaryKey: true)
            t.column(title_e)
            t.column(description_e)
            t.column(startTime_e)
            t.column(endTime_e)
            t.column(notificationTimeOffset_e)
        })
        
        block(events, db)
    }
    
    class func eventsOnDate(date: NSDate) -> [Event] {
        var evvents = [Event]()
        
        Event.events() { events, db in
        
            let units: NSCalendarUnit = [.Year, .Month, .Day, .Hour, .Minute, .Second]
            let comps = NSCalendar.currentCalendar().components(units, fromDate: date)
            comps.hour = 0
            comps.minute = 0
            comps.second = 0
            let startOfDay = NSCalendar.currentCalendar().dateFromComponents(comps)!
            comps.day += 1
            let endOfDay = NSCalendar.currentCalendar().dateFromComponents(comps)!
            
            let results = db.prepare(events.filter(startTime_e >= startOfDay).filter(endTime_e <= endOfDay).order(startTime_e))
            
            for res in results {
                evvents.append(Event(row: res))
            }
        }
        
        return evvents
    }
    
    class func each(block: (Event -> ())) { 
        Event.events() { events, db in
            for e in db.prepare(events) {
                block(Event(row: e))
            }
        }

    }
    
}
