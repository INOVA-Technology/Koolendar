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
    let events: Query
    
    let id   = Expression<Int>("id")
    let name = Expression<String>("name")
    
    let desc = Expression<String>("desc")
    let allDay = Expression<Bool>("allDay")
    
    let startHour = Expression<Int>("startHour")
    let endHour   = Expression<Int>("endHour")
    let startMinute = Expression<Int>("startMinute")
    let endMinute   = Expression<Int>("endMinute")
    
    let day = Expression<Int>("day")
    let month = Expression<Int>("month")
    let year = Expression<Int>("year")
    
    init() {
        
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true).first as String
        
        db = Database("\(path)/KoolendarEventsList.sqlite3")
        events = db["events"]
        
        db.create(table: events, ifNotExists: true) { t in
            t.column(self.id)
            t.column(self.name)
            t.column(self.desc)
            t.column(self.allDay)
            t.column(self.startHour)
            t.column(self.endHour)
            t.column(self.startMinute)
            t.column(self.endMinute)
            t.column(self.day)
            t.column(self.month)
            t.column(self.year)
        }
    }

    func addEvent(#name: String, description: String, date: NSDateComponents, startTime: NSDateComponents, endTime: NSDateComponents, allDay: Bool) {
        
        if let insertId = events.insert(
            id <- events.count,
            self.name <- name, // self is used here because of the name conflict
            desc <- description,
            self.allDay <- allDay, // self is used here because of the name conflict
            startHour <- startTime.hour,
            endHour <- endTime.hour,
            startMinute <- startTime.minute,
            endMinute <- endTime.minute,
            day <- date.day,
            month <- date.month,
            year <- date.year) {
        }
    }
    
    func eventsForDay(day: Int, month: Int, year: Int) -> [Event] {
        var eventList = [Event]()
        let cal = NSCalendar.currentCalendar()
        
        let results = events.filter(self.day == day && self.month == month && self.year == year)
        for result in results {
//            if !(result[self.day] == day && result[self.month] == month && result[self.year] == year) {
//                continue
//            }
            let date = NSDateComponents()
            date.day = day
            date.month = month
            date.year = year
            
            let startComps = NSDateComponents()
            startComps.hour = result[startHour]
            startComps.minute = result[startMinute]
            
            let endComps = NSDateComponents()
            endComps.hour = result[endHour]
            endComps.minute = result[endMinute]

            let event = Event(name: result[name] as String, description: result[desc] as String, date: date, startTime: startComps, endTime: endComps, allDay: result[allDay] as Bool)
            
            eventList.append(event)
        }
        
        return eventList
    }
}