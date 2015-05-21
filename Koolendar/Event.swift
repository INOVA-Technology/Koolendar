//
//  Event.swift
//  Koolendar
//
//  Created by Addison Bean on 5/21/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import Foundation

class Event {
    
    var id: Int?
    var title: String
    var startDate: NSDate
    var endDate: NSDate?
    var allDay = false
    
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
        self.id = Event.all.count // this may not be compatable with EKEvents, idk
        
        // save what we can in an EKEvent, and put the rest into the db
    }
    
    // ugly workaround for class vars below
    
    private struct ClassVariables {
        static var all: [Event] = []
    }
    
    class var all: [Event] {
        get {
        return ClassVariables.all
        }
        set {
            ClassVariables.all = newValue
        }
    }
    
}