//
//  Event.swift
//  Koolendar
//
//  Created by Addison Bean on 2/20/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import Foundation

class Event {
    
    let name: String
    let desc: String
    let allDay: Bool
    
    let startDate: NSDate
    let endDate: NSDate
    
    let startHour: Int
    let endHour: Int
    let startMinute: Int
    let endMinute: Int
    
    let day: Int
    let month: Int
    let year: Int
    
    init(name: String, description: String, startDate: NSDate, endDate: NSDate, allDay: Bool) {
        
        self.name = name
        desc = description
        self.allDay = allDay
        self.startDate = startDate
        self.endDate = endDate
        
        let cal = NSCalendar.currentCalendar()
        let units: NSCalendarUnit = .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute
        
        let startComps = cal.components(units, fromDate: startDate)
        day = startComps.day
        month = startComps.month
        year = startComps.year
        startHour = startComps.hour
        startMinute = startComps.minute
        
        let endComps = cal.components(units, fromDate: endDate)
        endHour = endComps.hour
        endMinute = endComps.minute
    }
    
    var writtenMonth: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM"
        let todayDate = formatter.monthSymbols
        return todayDate[month - 1] as String
    }
    
}
