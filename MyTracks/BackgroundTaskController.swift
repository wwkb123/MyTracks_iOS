//
//  BackgroundViewController.swift
//  MyTracks
//
//  Created by Yiu Chung Yau on 6/27/17.
//  Copyright © 2017 Yiu Chung Yau. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import GooglePlaces
import GoogleMaps

class BackgroundTaskController:UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate{
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    var sec=0.0
    var zeroTime = TimeInterval()
    var timer : Timer? = Timer()
    let locationManager = CLLocationManager()
    
    func onStart(){
        // register background task
        registerBackgroundTask()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.eachSecond(timer:)), userInfo: nil, repeats: true)
        zeroTime = Date.timeIntervalSinceReferenceDate
        
        distanceTraveled = 0.0
        startLocation = nil
        lastLocation = nil
        
        locationManager.startUpdatingLocation()
        ReachabilityManager.shared.startMonitoring()
        
        
    }
    func onStop(){
        timer?.invalidate()
        timer = nil
        locationManager.stopUpdatingLocation()
        // end background task
        endBackgroundTask()
    }
  func eachSecond(timer: Timer) {
        //seconds += 1.00
        //        let secondsQuantity = HKQuantity(unit: HKUnit.second(), doubleValue: seconds)
        //        totalTime.text = "Time: " + secondsQuantity.description
        //        let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: distance)
        //        totalDistance.text = "Distance: " + distanceQuantity.description
        
        
        //        totalTime.text = String(seconds) + "s"
        //        totalDistance.text = String(distance) + "km"
        //        let paceUnit = HKUnit.second().unitDivided(by: HKUnit.meter())
        //        let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: seconds / distance)
        //        avgSpeed.text = "Pace: " + paceQuantity.description
        sec+=1.00
        
        let currentTime = Date.timeIntervalSinceReferenceDate
        var timePassed: TimeInterval = currentTime - zeroTime
        let hours = UInt8(timePassed / 3600.0)
        timePassed -= (TimeInterval(hours) * 3600.0)
        let minutes = UInt8(timePassed / 60.0)
        timePassed -= (TimeInterval(minutes) * 60)
        let seconds = UInt8(timePassed)
        timePassed -= TimeInterval(seconds)
        //let millisecsX10 = UInt8(timePassed * 100)
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        //let strMSX10 = String(format: "%02d", millisecsX10)
        
        timeString = "\(strHours):\(strMinutes):\(strSeconds)"
    // \(strMSX10)
        let speed=(distanceTraveled / (sec/3600.0))
    if (movingTime>10 && speed > maxSpeed){
        maxSpeed = speed
    }
        let speed2=String(format:"%.0f", speed)
        speedString = "\(speed2) km/h"
    }
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskInvalid)
    }
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }
    
//    func getHealthKitPermission() {
//        
//        // Seek authorization in HealthKitManager.swift.
//        healthManager.authorizeHealthKit { (authorized,  error) -> Void in
//            if authorized {
//                
//                // Get and set the user's height.
//                self.setHeight()
//            } else {
//                if error != nil {
//                    print(error as Any)
//                }
//                print("Permission denied.")
//            }
//        }
//    }
//    
    
    
    
    
    
    //functions below are reserved for later purposes
    
    
    
    
//    func setHeight() {
//        // Create the HKSample for Height.
//        let heightSample = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)
//        
//        // Call HealthKitManager's getSample() method to get the user's height.
//        self.healthManager.getHeight(heightSample!, completion: { (userHeight, error) -> Void in
//            
//            if( error != nil ) {
//                print("Error: \(error?.localizedDescription ?? "Error")")
//                return
//            }
//            
//            var heightString = ""
//            
//            self.height = userHeight as? HKQuantitySample
//            
//            // The height is formatted to the user's locale.
//            if let meters = self.height?.quantity.doubleValue(for: HKUnit.meter()) {
//                let formatHeight = LengthFormatter()
//                formatHeight.isForPersonHeightUse = true
//                heightString = formatHeight.string(fromMeters: meters)
//            }
//            
//            // Set the label to reflect the user's height.
//            DispatchQueue.main.async(execute: { () -> Void in
//                //                self.avgSpeed.text = heightString
//            })
//        })
//        
//    }
}
