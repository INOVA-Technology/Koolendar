// Playground - noun: a place where people can play

import UIKit
// import SQLite
import Foundation
import SQLite


let dbDir = NSSearchPathForDirectoriesInDomains(
    .DocumentDirectory, .UserDomainMask, true).first as String
let dbPath = "\(dbDir)/KoolendarDB.sqlite3"

//NSFileManager.defaultManager().removeItemAtPath(dbPath, error: nil)

//let db = Database(dbPath)
//
//let ids = db["events"]
//
//let eventId = Expression<Int>("id")
//let ekEventId = Expression<String>("ekEventId")
//
//db.create(table: ids, ifNotExists: true) { t in
//    t.column(eventId, primaryKey: true)
//    t.column(ekEventId, unique: true)
//}

//ids.count

//ids.filter(eventId == 1)

//ids.first[ids[eventId]]
//
//db["events"].insert(eventId <- 5, ekEventId <- "BLArqeHdqefagsgseqfffqwefq")!
//db["events"].insert(eventId <- 6, ekEventId <- "BLrerAHrqfggag")!

//ids.count
