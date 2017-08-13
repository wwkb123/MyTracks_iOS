//
//  Settings.swift
//  MyTracks
//
//  Created by Yiu Chung Yau on 7/7/17.
//  Copyright © 2017 Yiu Chung Yau. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Foundation
import GooglePlaces
import GoogleMaps
import Firebase
import FirebaseDatabase


class Settings: UIViewController,CLLocationManagerDelegate {
    @IBOutlet weak var gpsLabel: UILabel!
    @IBOutlet weak var netLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var trackLabel: UILabel!
    let locationManager = CLLocationManager()
    let userData=User()
    let track=Track()
    var array = ["a":"l","k":"ad"]  //testing
    let defaults = UserDefaults.standard
    
    
   
    
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text=userData.getUserName()
        trackLabel.text=userData.getTrackNo()
        print(userData.getWeight())
        print(userData.getNcar())
        print(userData.getPrimode())
        print(userData.getCategory())
        
        array["asd"]="asd"
        defaults.set(array, forKey: "SavedStringarray")
        
        let myarray = defaults.dictionary(forKey: "SavedStringarray") ?? [String:Any]()
        print(myarray)
    }
    

     @IBAction func onResetClick(_ sender: UIButton) {
        //userData.reset()
        userData.setUserName("shenghui")
    }
    
     @IBAction func onUpdateClick(_ sender: UIButton) {
        
        netLabel.text=String(ReachabilityManager.shared.reachability.isReachable)
        gpsLabel.text=String(Int((locationManager.location?.horizontalAccuracy ?? 999)!) )
    }
}

