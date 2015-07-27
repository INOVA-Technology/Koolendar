//
//  Event.swift
//  Koolendar
//
//  Created by Addison Bean on 5/21/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import Foundation
import SQLite

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
    
}
