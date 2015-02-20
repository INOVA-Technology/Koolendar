//
//  EventManager.swift
//  Koolendar
//
//  Created by Addison Bean on 2/19/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import Foundation
import SQLite

class EventManager {
    
    let db: Database
    let id:   Expression<Int>
    let startDate: Expression<Double>
    let endDate: Expression<Double>
    let name: Expression<String>
    let desc: Expression<String>
    let events: Query
    
    init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true).first as String
        
        db = Database("\(path)/KoolendarEventsList.sqlite3")
        id   = Expression<Int>("id")
        startDate = Expression<Double>("startDate")
        endDate = Expression<Double>("endDate")
        name = Expression<String>("name")
        desc = Expression<String>("desc")
        events = db["events"]
        
        db.create(table: events, ifNotExists: true) { t in
            t.column(self.id, primaryKey: true)
            t.column(self.name)
            t.column(self.desc)
            t.column(self.startDate)
            t.column(self.endDate)
        }

        func addEvent(startDate: NSDate, endDate: NSDate, name: String, description: String) {
            let s_timestamp: Double = Double(startDate.timeIntervalSince1970)
            let e_timestamp: Double = Double(endDate.timeIntervalSince1970)
            events.insert(id <- events.count, self.name <- name, desc <- description, self.startDate <- s_timestamp, self.endDate <- e_timestamp)
        }
    }
}