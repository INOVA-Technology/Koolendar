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
    
//    let startDate: NSDate
//    let endDate: NSDate
//    
//    let startHour: Int
//    let endHour: Int
//    let startMinute: Int
//    let endMinute: Int
//    
//    let day: Int
//    let month: Int
//    let year: Int

    let date: NSDateComponents
    let startTime: NSDateComponents
    let endTime: NSDateComponents
    
    init(name: String, description: String, date: NSDateComponents, startTime: NSDateComponents, endTime: NSDateComponents, allDay: Bool) {
        
        self.name = name
        desc = description
        self.allDay = allDay
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
    }
}
