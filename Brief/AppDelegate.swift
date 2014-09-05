//
//  AppDelegate.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/8/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    let cloudManager = BriefCloudManager()
    
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // Register for push notifications
        var notificationSettings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()
        
        // enhance this code to pull user info locally and using identity management prior to hitting iCloud
        self.cloudManager.requestDiscoverabilityPermission({ discoverability in
            
            if (discoverability) {
                
                self.cloudManager.discoverUserInfo({ userInfo in
                    
                    // assign the user information
                    user.userInfo = userInfo
                                        
                    self.cloudManager.fetchRecordWithID(user.userInfo!.userRecordID.recordName, completionClosure: { record in
                        
                        user.preferredName = record.objectForKey("preferredName") as? String
                        user.loadBriefReviewers(2) //replace with cloudKit call

                        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: NSBundle.mainBundle())
                        let briefNavVC = UINavigationController(rootViewController: homeVC)
                        
                        //nav bar setup
//                        briefNavVC.navigationBar.barTintColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
//                        briefNavVC.navigationBar.tintColor = UIColor.darkGrayColor()
//                        briefNavVC.navigationBar.barStyle = UIBarStyle.Default
                        
                        //nav bar setup
                        briefNavVC.navigationBar.barTintColor = UIColor.blackColor()
                        briefNavVC.navigationBar.tintColor = UIColor.whiteColor()
                        briefNavVC.navigationBar.barStyle = UIBarStyle.BlackTranslucent
                        
                        self.window?.rootViewController = briefNavVC
                        self.window?.backgroundColor = UIColor.whiteColor()
                        self.window?.makeKeyAndVisible()
                        
                    })
                    

             
                })
                
            } else {
                
                let homeVC = EnableAccount(nibName: "EnableAccount", bundle: NSBundle.mainBundle())
                let briefNavVC = UINavigationController(rootViewController: homeVC)
                
                //nav bar setup
                briefNavVC.navigationBar.barTintColor = UIColor.blackColor()
                briefNavVC.navigationBar.tintColor = UIColor.whiteColor()
                briefNavVC.navigationBar.barStyle = UIBarStyle.BlackTranslucent
                
                self.window?.rootViewController = briefNavVC
                self.window?.backgroundColor = UIColor.whiteColor()
                self.window?.makeKeyAndVisible()
            }
            
        })
    
        
        return true

    }

    func applicationWillResignActive(application: UIApplication!) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication!) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication!) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication!) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication!) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        println("Registered for Push notifications with token: \(deviceToken)")
    }
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("Push subscription failed: \(error)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        println("Push received with alert body:: \(userInfo)")
        
        var cloudKitNotification = CKNotification(fromRemoteNotificationDictionary: userInfo)
        
        if(cloudKitNotification.notificationType == CKNotificationType.Query) {
            var queryNotification = cloudKitNotification as CKQueryNotification
            var recordID = queryNotification.recordID
            var publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
            
            publicDatabase.fetchRecordWithID(recordID, completionHandler: { record, error in
                
                if (error != nil) {
                    println("\(error)")
                } else {
                    NSNotificationCenter.defaultCenter().postNotificationName("test", object: record)
                }
            })
            
        }

    }
    
    
}

