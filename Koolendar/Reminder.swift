//
//  Reminder.swift
//  Koolendar
//
//  Created by Addison Bean on 10/31/15.
//  Copyright © 2015 INOVA. All rights reserved.
//

import Foundation
import SQLite

private let id_r = Expression<Int>("id")
private let title_r = Expression<String>("title")
private let description_r = Expression<String>("description")
private let time_r = Expression<NSDate>("time")
private let calendarId_r = Expression<Int>("calendarId")

private let id_c = Expression<Int>("id")
private let name_c = Expression<String>("name")

class Reminder {
    
    class func reminders(block: (Table, Connection) -> Void) {
        Reminder.db({ db, reminders, _ in block(reminders, db) })
    }
    
    class func calendars(block: (Table, Connection) -> Void) {
        Reminder.db({ db, _, calendars in block(calendars, db) })
    }
    
//    class var allCalendars: [Calendar] {
//        var calsToReturn = [Calendar]()
//        Event.calendars { cals, db in
//            for cal in db.prepare(cals) {
//                calsToReturn.append((name: cal.get(name_c), id: cal.get(id_c)))
//            }
//        }
//        return calsToReturn
//    }

    class private func db(block: (Connection, Table, Table) -> Void) {
        let dbDir = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true).first!
        let db = try! Connection("\(dbDir)/KoolendarDB.sqlite3")
        
        let reminders = Table("reminders")
        
        try! db.run(reminders.create(ifNotExists: true) { t in
            t.column(id_r, primaryKey: true)
            t.column(title_r)
            t.column(description_r)
            t.column(time_r)
            t.column(calendarId_r)
        })
        
        let calendars = Table("calendars")
        try! db.run(calendars.create(ifNotExists: true) { t in
            t.column(id_c, primaryKey: true)
            t.column(name_c)
        })
        
        if db.scalar(calendars.count) == 0 {
            try! db.run(calendars.insert(name_c <- "Primary"))
        }
        
        block(db, reminders, calendars)
    }
    
//    func save() {
//        Reminder.reminders() { reminders, db in
//            if let id = self.id {
//                let _ = try? db.run(reminders.filter(id_r == id).update(title_r <- self.title, description_r <- self.description, time_r <- self.time, calendarId_r <- self.calendarId))
//            } else {
//                do {
//                    let id = try db.run(reminders.insert(title_r <- self.title, description_r <- self.description, time_r <- self.time, calendarId_r <- self.calendarId))
//                    self.id = Int(id)
//                } catch {
//                    print("couldn't save the event 😞")
//                    print(error)
//                }
//            }
//        }
//        
//    }
    
}
