//
//  Event.swift
//  Koolendar
//
//  Created by Addison Bean on 5/21/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import Foundation
import EventKit
import SQLite

var eventsOnHelperVar = [EKEvent]()

class Event {
    
    let ekEvent = EKEvent(eventStore: Event.eventStore)
    
    var title: String {
        get { return self.ekEvent.title }
        set { self.ekEvent.title = newValue }
    }
    
    var startDate: NSDate {
        get { return self.ekEvent.startDate }
        set { self.ekEvent.startDate = newValue }
    }
    
    var endDate: NSDate {
        get { return self.ekEvent.endDate }
        set { self.ekEvent.endDate = newValue }
    }
    
    var allDay: Bool {
        get { return self.ekEvent.allDay }
        set { self.ekEvent.allDay = newValue }
    }
    
    var id: Int?
    
    init(title: String, startDate: NSDate, endDate: NSDate?) {
        self.title = title
        self.startDate = startDate
        if let endDate = endDate {
            self.endDate = endDate
        } else {
            self.endDate = startDate.dateByAddingTimeInterval(86400) // 24 * 60 * 60, 1 day
            self.allDay = true
        }
        
    }
    
    func save() {
        Event.eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {
            gotAccess, error in
            // save what we can in an EKEvent, and put the rest into the db
            var error : NSError? = nil
            
            self.ekEvent.calendar = Event.eventStore.defaultCalendarForNewEvents
            Event.eventStore.saveEvent(self.ekEvent, span: EKSpanThisEvent, commit: true, error: &error)
            
            let eventId = Expression<Int>("id")
            let ekEventId = Expression<String>("ekEventId")
            
            if let id = self.id {
                let results = Event.db["events"].filter(id == eventId)
                if let result = results.first {
                    // update the row, including the ekEventId which I think will have changed
                } else {
                    // if this point is reached, then we have a problem
                }
            } else {
                self.id = Event.nextId
                Event.nextId++
                if let idk = Event.db["events"].insert(eventId <- self.id!, ekEventId <- self.ekEvent.eventIdentifier) {
                    Event.all.append(self)
                }
            }
        })
    }
    
    class func requestEventKitPermission() {
        Event.eventStoreAccess = EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent)
        if Event.eventStoreAccess == .NotDetermined {
            Event.eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {
                gotAccess, error in
                
            })
        }
    }
    
    class func initDB() {
        
        // finds an EKEvent by using the Event id, or vice versa
        // I think this table is unnecessary
        let ids = self.db["events"]
        
        let eventId = Expression<Int>("id")
        let ekEventId = Expression<String>("ekEventId")
        
        self.db.create(table: ids, ifNotExists: true) { t in
            t.column(eventId, primaryKey: true)
            t.column(ekEventId, unique: true)
        }
        
        let settings = self.db["settings"]
        
        let settingsId = Expression<Int>("id")
        let key = Expression<String>("key")
        let values = Expression<String>("value")
        
        self.db.create(table: settings, ifNotExists: true) { t in
            t.column(settingsId, primaryKey: true)
            t.column(key, unique: true)
            t.column(values)
        }
    }
    
    class func eventsOn(date: NSDate) -> [Event] {
        // TODO: make this async, as well as other things
        var events = [Event]()
        var ekEvents = [EKEvent]()
        
        let queue = dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)

        dispatch_sync(queue, { () -> Void in
            Event.eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {
                gotAccess, error in
                let cal = NSCalendar.currentCalendar()
                var comps = cal.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: date)
                
                let aFewHoursAgo = NSDateComponents()
                aFewHoursAgo.hour = -5
                
                var daStartDate = cal.dateFromComponents(comps)!
                daStartDate = cal.dateByAddingComponents(aFewHoursAgo, toDate: daStartDate, options: .allZeros)!
                
                var aDay = NSDateComponents()
                aDay.day = 1
                
                var daEndDate = cal.dateByAddingComponents(aDay, toDate: daStartDate, options: .allZeros)!
                daEndDate = daEndDate.dateByAddingTimeInterval(-1)!
                
                let p = Event.eventStore.predicateForEventsWithStartDate(daStartDate, endDate: daEndDate, calendars: [Event.eventStore.defaultCalendarForNewEvents])
                let tmp = Event.eventStore.eventsMatchingPredicate(p) as [EKEvent]?
                if let idk = tmp {
                    ekEvents = tmp!
                }
                
                let ekEventId = Expression<String>("ekEventId")
                let eventId = Expression<Int>("id")
                
                for ekEvent in ekEvents {
                    let evnt = Event.db["events"]
                    // This is dangerous, I think. Specificly the !'s
                    var daEventId:AnyObject!
                    daEventId = evnt.filter(ekEventId == ekEvent.eventIdentifier).first![evnt[eventId]]
//                    events.append(Event.eventWithId(daEventId)!)
                    println(daEventId)
                    
                }
            })
        })

        return events
    }
    
    class func eventWithId(id: Int) -> Event? {
        let eventId = Expression<Int>("id")
        let ekEventId = Expression<String>("ekEventId")
        
        if let eventFromDb = Event.db["events"].filter(eventId == id).first {
            let daEkEventId = eventFromDb[ekEventId]
            let ekEvent = Event.eventStore.eventWithIdentifier(daEkEventId)
            return Event(title: ekEvent.title, startDate: ekEvent.startDate, endDate: ekEvent.endDate)
        } else {
            return nil
        }
    }
    
    
    
    
    
    // ugly workaround for class vars below
    
    private struct ClassVariables {
        static var all: [Event] = []
        static let eventStore = EKEventStore()
        static var eventStoreAccess: EKAuthorizationStatus!
        static let dbDir = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true).first as String
        static let dbPath = "\(dbDir)/KoolendarDB.sqlite3"
        static let db = Database(dbPath)
        static var eventsOnHelper = [EKEvent]()
    }
    
    class var all: [Event] {
        get { return ClassVariables.all }
        set { ClassVariables.all = newValue }
    }
    
    class var eventStore: EKEventStore {
        get { return ClassVariables.eventStore }
    }
    
    class var eventStoreAccess: EKAuthorizationStatus {
        get { return ClassVariables.eventStoreAccess }
        set { ClassVariables.eventStoreAccess = newValue }
    }
    
    class var dbDir: String {
        get { return ClassVariables.dbDir }
    }
    
    class var dbPath: String {
        get { return ClassVariables.dbPath }
    }
    
    class var db: Database {
        get { return ClassVariables.db }
    }
    
//    class var eventsOnHelper: [EKEvent] {
//        get { return ClassVariables.eventsOnHelper }
//        set { ClassVariables.eventsOnHelper = newValue }
//    }
    
    class var nextId: Int {
        get {
            let table = self.db["settings"]
            let key = Expression<String>("key")
            let value = Expression<String>("value")
        
            if let first = table.filter(key == "nextId").first {
                return first.get(value).toInt()!
            } else {
                table.insert(key <- "nextId", value <- "0")!
                return 0
            }
        }
        
        set {
            let table = self.db["settings"]
            let key = Expression<String>("key")
            let value = Expression<String>("value")
            
            if let first = table.filter(key == "nextId").first {
                table.filter(key == "nextId").update(value <- String(newValue))!
            } else {
                table.insert(key <- "nextId", value <- String(newValue))!
            }
        }
    }
    
}
