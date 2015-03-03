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
    
    let startHour = Expression<Int?>("startHour")
    let endHour   = Expression<Int?>("endHour")
    let startMinute = Expression<Int?>("startMinute")
    let endMinute   = Expression<Int?>("endMinute")
    
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

    func addEvent(#name: String, description: String, date: NSDateComponents, startTime: NSDateComponents?, endTime: NSDateComponents?, allDay: Bool) {
        
        var da_hour_s: Int?
        var da_hour_e: Int?
        var da_min_s: Int?
        var da_min_e: Int?
        println(startTime!.hour)
        println(startTime!.minute)
        if allDay == false {
            println("yes")
            da_hour_s = startTime!.hour
            da_hour_e =   endTime!.hour
            da_min_s  = startTime!.minute
            da_min_e  =   endTime!.minute
        } else {
            println("no")
        }
        println("sjdflksndflkandflkaslfdknalksdflkadflkasdf;lkasdklfas\(da_min_s)")
        
        if let insertId = events.insert(
            id <- events.count,
            self.name <- name, // self is used here because of the name conflict
            desc <- description,
            self.allDay <- allDay, // self is used here because of the name conflict
            self.startHour <- da_hour_s,
            endHour <- da_hour_e,
            self.startMinute <- da_min_s,
            endMinute <- da_min_e,
            day <- date.day,
            month <- date.month,
            year <- date.year) {
        }
        for event in events {
            println("allday?:\(event[self.allDay])")
            println("start times?: \(event[startHour]!)")
            
        }
        println("lets hope it works\(startTime?.hour)")
    }
    
    func eventsForDay(day: Int, month: Int, year: Int) -> [Event] {
        var eventList = [Event]()
        let cal = NSCalendar.currentCalendar()
        
        let results = events.filter(self.day == day && self.month == month && self.year == year)
        for result in results {
            
            let date = NSDateComponents()
            date.day = day
            date.month = month
            date.year = year
            
            var startComps: NSDateComponents?
            var endComps: NSDateComponents?
            
            if result[allDay] {
                let startComps = NSDateComponents()
                startComps.hour = result[startHour]!
                startComps.minute = result[startMinute]!
                
                let endComps = NSDateComponents()
                endComps.hour = result[endHour]!
                endComps.minute = result[endMinute]!
            }

            let event = Event(name: result[name] as String, description: result[desc] as String, date: date, startTime: startComps, endTime: endComps, allDay: result[allDay] as Bool, id: result[id])
            
            eventList.append(event)
        }
        
        return eventList
    }
    
    var allEvents: [Event] {
        var list = [Event]()
        for event in events {
            let id = event[self.id]
            let name = event[self.name]
            let desc = event[self.desc]
            let allDay = event[self.allDay]
            var startTime: NSDateComponents?
            var endTime: NSDateComponents?
            
            if !allDay {
                startTime = NSDateComponents()
                startTime!.hour = event[self.startHour]!
                startTime!.minute = event[self.startMinute]!
                
                
                endTime = NSDateComponents()
                endTime!.hour = event[self.endHour]!
                endTime!.minute = event[self.endMinute]!
            }
            let date = NSDateComponents()
            date.day = event[self.day]
            date.month = event[self.month]
            date.year = event[self.year]
            
            let event = Event(name: name, description: desc, date: date, startTime: startTime, endTime: endTime, allDay: allDay, id: id)
            list.append(event)
            
        }
        
        return list
    }
}