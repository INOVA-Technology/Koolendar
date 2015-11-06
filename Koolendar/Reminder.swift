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
private let time_r = Expression<NSDate>("time")
private let calendarId_r = Expression<Int>("calendarId")

private let id_c = Expression<Int>("id")
private let name_c = Expression<String>("name")

class Reminder {
    
    private var _title: String?
    var title: String {
        set {
            _title = newValue
        }
        get {
            if let title = self._title {
                return title
            } else {
                self._title = self.sqlRow!.get(title_r)
                return self._title!
            }
        }
    }
    
    private var _time: NSDate?
    var time: NSDate {
        set {
            _time = newValue
        }
        get {
            if let time = self._time {
                return time
            } else {
                self._time = self.sqlRow!.get(time_r)
                return self._time!
            }
        }
    }

    var _id: Int?
    var id: Int? {
        set {
            _id = newValue
        }
        get {
            if let id = self._id {
                return id
            } else if let row = self.sqlRow {
                self._id = row.get(id_r)
                return self._id
            } else {
                return nil
            }
        }
    }
    
    var _calendarId: Int?
    var calendarId: Int {
        set {
            _calendarId = newValue
        }
        get {
            if let calendarId = self._calendarId {
                return calendarId
            } else if let row = self.sqlRow {
                self._calendarId = row.get(calendarId_r)
                return self._calendarId!
            } else {
                return 1
            }
        }
    }
    
    var sqlRow: Row?
    
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
    
    init(title: String, time: NSDate, calendarId: Int?, id: Int?) {
        self.title = title
        self.time = time
        if let calendarId = calendarId { self.calendarId = calendarId }
        self.id = id
    }
    
    init(row: Row) {
        self.sqlRow = row
    }

    class private func db(block: (Connection, Table, Table) -> Void) {
        let dbDir = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true).first!
        let db = try! Connection("\(dbDir)/KoolendarDB.sqlite3")
        
        let reminders = Table("reminders")
        
        try! db.run(reminders.create(ifNotExists: true) { t in
            t.column(id_r, primaryKey: true)
            t.column(title_r)
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
    
    func save() {
        Reminder.reminders() { reminders, db in
            if let id = self.id {
                let _ = try? db.run(reminders.filter(id_r == id).update(title_r <- self.title, time_r <- self.time, calendarId_r <- self.calendarId))
            } else {
                do {
                    let id = try db.run(reminders.insert(title_r <- self.title, time_r <- self.time, calendarId_r <- self.calendarId))
                    self.id = Int(id)
                } catch {
                    print("couldn't save the event 😞")
                    print(error)
                }
            }
        }
    }
    
    func delete() {
        guard let id = self.id else {
            print("couldn't delete an event that hasn't been saved")
            return
        }
        
        Reminder.reminders() { reminders, db in
            let _ = try? db.run(reminders.filter(id_r == id).delete())
        }
    }
    
    class func each(block: (Reminder -> ())) {
        Reminder.reminders() { reminders, db in
            for e in db.prepare(reminders) {
                block(Reminder(row: e))
            }
        }
    }
    
}
