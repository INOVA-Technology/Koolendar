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

class Event {
    
    let ekEvent = EKEvent()
    
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
        // save what we can in an EKEvent, and put the rest into the db
        Event.eventStore.saveEvent(self.ekEvent, span: EKSpanThisEvent, commit: true, error: nil)
        
        let eventId = Expression<Int>("eventId")
        let ekEventId = Expression<String>("ekEventId")
        
        if let id = self.id {
            let results = Event.db["ids"].filter(self.id! == eventId)
            if let result = results.first {
                // update the row, including the ekEventId which I think will have changed
            }
        } else {
            self.id = Event.nextId
            Event.nextId++
            Event.db["ids"].insert(eventId <- self.id!, ekEventId <- self.ekEvent.eventIdentifier)!
        }
    
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
        let ids = self.db["ids"]
        
        let eventId = Expression<Int>("eventId")
        let ekEventId = Expression<String>("ekEventId")
        
        self.db.create(table: ids, ifNotExists: true) { t in
            t.column(eventId, primaryKey: true)
            t.column(ekEventId)
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
        static var nextId = 0
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
    
    class var nextId: Int {
        get { return ClassVariables.nextId }
        set { ClassVariables.nextId = newValue }
    }
    
}
