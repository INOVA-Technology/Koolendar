//
//  EventManager.swift
//  Koolendar
//
//  Created by Addison Bean on 2/19/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import Foundation
import EventKit

class EventManager {
    
    let store = EKEventStore()
    let access: EKAuthorizationStatus
    
    class var sharedInstance: EventManager {
        struct Static {
            static let instance: EventManager = EventManager()
        }
        return Static.instance
    }
    
    init() {
        access = EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent)
        if access == .NotDetermined {
            store.requestAccessToEntityType(EKEntityTypeEvent, completion: {
                gotAccess, error in
            })
        }
    }

    func addEvent(#title: String, notes: String?, startDate: NSDate, endDate: NSDate?) {
        let event = EKEvent(eventStore: store)
        event.calendar = store.defaultCalendarForNewEvents
        event.startDate = startDate
        event.title = title
        
        if notes != nil {
            event.notes = notes
        }
        
        if endDate != nil {
            event.endDate = endDate
        }
        
        store.saveEvent(event, span: EKSpanThisEvent, commit: true, error: nil)
    }
    
    func eventsForDay(day: Int, month: Int, year: Int) -> [EKEvent]? {
        let cal = NSCalendar.currentCalendar()
        
        let startComps = NSDateComponents()
        startComps.day = day
        startComps.month = month
        startComps.year = year
        let startDate = cal.dateFromComponents(startComps)
        
        if startDate == nil {
            return nil
        }
        
        let endComps = NSDateComponents()
        endComps.day = day + 1
        let endDate = cal.dateByAddingComponents(endComps, toDate: startDate!, options: nil)
 
        if endDate == nil {
            return nil
        }
        
        let predicate = store.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: nil)
        println(predicate)
        return store.eventsMatchingPredicate(predicate) as? [EKEvent]
    }
}