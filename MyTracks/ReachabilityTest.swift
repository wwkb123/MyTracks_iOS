//
//  Reachability.swift
//  MyTracks
//
//  Created by Yiu Chung Yau on 7/11/17.
//  Copyright © 2017 Yiu Chung Yau. All rights reserved.
//

import UIKit
import ReachabilitySwift // 1. Importing the Library
class ReachabilityManager: NSObject {
    static  let shared = ReachabilityManager()  // 2. Shared instance

// 3. Boolean to track network reachability
var isNetworkAvailable : Bool {
    return reachabilityStatus != .notReachable
}
// 4. Tracks current NetworkStatus (notReachable, reachableViaWiFi, reachableViaWWAN)
var reachabilityStatus: Reachability.NetworkStatus = .notReachable
// 5. Reachability instance for Network status monitoring
let reachability = Reachability()!

/// Called whenever there is a change in NetworkReachibility Status
///
/// — parameter notification: Notification with the Reachability instance
func reachabilityChanged(notification: Notification) {
    let reachability = notification.object as! Reachability
    switch reachability.currentReachabilityStatus {
    case .notReachable:
        debugPrint("Network became unreachable")
    case .reachableViaWiFi:
        debugPrint("Network reachable through WiFi")
    case .reachableViaWWAN:
        debugPrint("Network reachable through Cellular Data")
    }
}

/// Starts monitoring the network availability status
func startMonitoring() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(self.reachabilityChanged),
                                           name: ReachabilityChangedNotification,
                                           object: reachability)
    do{
        try reachability.startNotifier()
    } catch {
        debugPrint("Could not start reachability notifier")
    }
}
}
