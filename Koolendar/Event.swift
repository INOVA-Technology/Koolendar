//
//  Event.swift
//  Koolendar
//
//  Created by Addison Bean on 2/20/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import Foundation

class Event {
    
    let day: Int
    let month: Int
    let year: Int
    let components: NSDateComponents
    
    init(day: Int, month: Int, year: Int) {
        self.day = day
        self.month = month
        self.year = year
        
        components = NSDateComponents()
        components.day = day
        components.month = month
        components.year = year
    }
    
    var writtenMonth: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM"
        let todayDate = formatter.monthSymbols
        return todayDate[components.month] as String
    }
    
}
