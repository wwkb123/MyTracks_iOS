//
//  AppDelegate.swift
//  MyTracks
//
//  Created by Yiu Chung Yau on 6/20/17.
//  Copyright © 2017 Yiu Chung Yau. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {

    var window: UIWindow?
    
    //global variables
    
    var isRecord=false
    var timeString=""
    var distanceString=0.0
    var speedString=""
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var lat=0.0
    var lon=0.0
    var lastLat=0.0
    var lastLon=0.0
    var track_x=0.0
    var track_y=0.0
    var track_z=0.0
    var movingTime = 0
    var movingTimeString=""
    var maxSpeed=0.0
    var avgMovSpeed=0.0
    var isLoadingHidden=true
    var isCurrClicked = false
    
    
    func notic(){
        //sending notification
        let content = UNMutableNotificationContent()
        content.title = "Check you result"
        content.subtitle = "The calculation is finished"
        content.body = "Click to check it"
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let trequest = UNNotificationRequest(identifier: "Finished", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(trequest, withCompletionHandler: nil)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
  

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyDv_IIEFyKVnCNtbnuX43RML2FtMalX1h0")
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]){(accepted, error)in
            if accepted{
                print("yes")
            }
            if !accepted{
                print("Denied")
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

