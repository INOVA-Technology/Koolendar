 //
//  AppDelegate.swift
//  tmp
//
//  Created by Addison Bean on 1/24/15.
//  Copyright (c) 2015 addisonbean. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // ColorScheme.currentTheme = .RedAurora
        
        let settings = UIUserNotificationSettings(forTypes: .Alert | .Sound | .Badge, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        registerDefaultsFromSettingsBundle()
        
        let scheme = NSUserDefaults.standardUserDefaults().stringForKey("color_scheme")!
        ColorScheme.currentTheme = ColorSchemeStyle(rawValue: scheme)!

        return true
    }
    
    func registerDefaultsFromSettingsBundle() {
        let settingsBundle = NSBundle.mainBundle().pathForResource("Settings", ofType: "bundle")!
        let settingsPath = settingsBundle.stringByAppendingPathComponent("Root.plist")
        
        let settings = NSDictionary(contentsOfFile: settingsPath)!
        
//        let prefs = settings.objectForKey("PreferenceSpecifiers") as! [NSDictionary]
//        var keyValuePairs = NSMutableDictionary()
        
//        for pref in prefs {
//            let prefType = pref["Type"] as! String
//            let prefKey = pref["Key"] as! String?
//            let prefDefaultValue = pref["DefaultValue"] as! NSObject?
//            
//            if prefType == "PSChildPaneSpecifier" {
//                // ugh
//            } else if prefKey != nil && prefDefaultValue != nil {
//                keyValuePairs[prefKey!] = prefDefaultValue
//            }
        NSUserDefaults.standardUserDefaults().registerDefaults(settings as! [NSObject : AnyObject])
        NSUserDefaults.standardUserDefaults().synchronize()
        
        if NSUserDefaults.standardUserDefaults().stringForKey("color_scheme") == nil {
            NSUserDefaults.standardUserDefaults().setValue("RedAurora", forKey: "color_scheme")
        }
        
//        if NSUserDefaults.standardUserDefaults().boolForKey("sound_effects_enabled") == nil {
//            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "sound_effects_enabled")
//        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        Event.each { e in
            let notif = UILocalNotification()
            notif.fireDate = e.notificationTime
            notif.timeZone = NSTimeZone.defaultTimeZone()
            notif.alertBody = e.title
            notif.soundName = UILocalNotificationDefaultSoundName
//            notif.alertAction = ...
            
            UIApplication.sharedApplication().scheduleLocalNotification(notif)
        }
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.addisonbean.tmp" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Koolendar", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Koolendar.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
}

