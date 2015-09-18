 //
//  AppDelegate.swift
//  tmp
//
//  Created by Addison Bean on 1/24/15.
//  Copyright (c) 2015 addisonbean. All rights reserved.
//

import UIKit
import CoreData
 
var colorSchemeValues: [(String, String)]!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // ColorScheme.currentTheme = .RedAurora
        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Sound, .Badge], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        registerDefaultsFromSettingsBundle()
        
        let scheme = NSUserDefaults.standardUserDefaults().stringForKey("color_scheme")!
        ColorScheme.currentTheme = ColorSchemeStyle(rawValue: scheme)!
        
        return true
    }
    
    func registerDefaultsFromSettingsBundle() {
        let settingsBundle = NSBundle.mainBundle().pathForResource("Settings", ofType: "bundle")!
        let settingsPath = NSURL(string: settingsBundle)!.URLByAppendingPathComponent("Root.plist")
        
        let settings = NSDictionary(contentsOfURL: settingsPath)!
        
        let prefs = settings["PreferenceSpecifiers"] as! [NSDictionary]
        for pref in prefs {
//            println(pref)
            if pref["Key"] as? String == "color_scheme" {
                colorSchemeValues = Array(zip(pref["Titles"] as! [String], pref["Values"] as! [String]))
            }
        }
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
        NSUserDefaults.standardUserDefaults().registerDefaults(settings as! [String : AnyObject])
        NSUserDefaults.standardUserDefaults().synchronize()
        
        if NSUserDefaults.standardUserDefaults().stringForKey("color_scheme") == nil {
            NSUserDefaults.standardUserDefaults().setValue("RedAurora", forKey: "color_scheme")
        }
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
    }
    
}

