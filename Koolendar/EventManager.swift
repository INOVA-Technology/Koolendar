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
            t.column(id, primaryKey: true)
            t.column(name)
            t.column(desc)
            t.column(startDate)
            t.column(endDate)
        }
        
        // this should work idk
        func addEvent(startDate: NSDate, endDate: NSDate, name: String, description: String) {
            let s_timestamp = date.timeIntervalSince1970
            let e_timestamp = date.timeIntervalSince1970
            events.insert(id <- events.count, startDate <- timestamp, endDate <- e_timestamp, self.name <- name, desc <- description)
        }
    }
}