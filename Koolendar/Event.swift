//
//  Event.swift
//  Koolendar
//
//  Created by Addison Bean on 5/21/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import Foundation
import EventKit

class Event {
    
    let ekEvent = EKEvent()
    
    var title: String {
        get { return self.ekEvent.title }
        set { self.ekEvent.title = newValue }
    }
    
    var startDate: NSDate {
        get { return self.ekEvent.startDate }
        set { self.ekEvent.startDate = newValue }
    }
    
    var endDate: NSDate {
        get { return self.ekEvent.endDate }
        set { self.ekEvent.endDate = newValue }
    }
    
    var allDay: Bool {
        get { return self.ekEvent.allDay }
        set { self.ekEvent.allDay = newValue }
    }
    
    var id: Int?
    
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
        
        Event.eventStore.saveEvent(self.ekEvent, span: EKSpanThisEvent, commit: true, error: nil)
        
        // save what we can in an EKEvent, and put the rest into the db
    }
    
    // ugly workaround for class vars below
    
    class func requestEventKitPermission() {
        Event.eventStoreAccess = EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent)
        if Event.eventStoreAccess == .NotDetermined {
            Event.eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {
                gotAccess, error in
            })
        }
    }
    
    private struct ClassVariables {
        static var all: [Event] = []
        static let eventStore = EKEventStore()
        static var eventStoreAccess: EKAuthorizationStatus!
    }
    
    class var all: [Event] {
        get { return ClassVariables.all }
        set { ClassVariables.all = newValue }
    }
    
    class var eventStore: EKEventStore {
        get { return ClassVariables.eventStore }
    }
    
    class var eventStoreAccess: EKAuthorizationStatus {
        get { return ClassVariables.eventStoreAccess }
        set { ClassVariables.eventStoreAccess = newValue }
    }
    
}
