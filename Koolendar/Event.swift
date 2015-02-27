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

    let date: NSDateComponents
    let startTime: NSDateComponents?
    let endTime: NSDateComponents?
    
    let id: Int
    
    init(name: String, description: String, date: NSDateComponents, startTime: NSDateComponents?, endTime: NSDateComponents?, allDay: Bool, id: Int) {
        
        self.name = name
        desc = description
        self.allDay = allDay
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.id = id
    }
}
