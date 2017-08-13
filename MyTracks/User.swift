//
//  Track.swift
//  MyTracks
//
//  Created by Yiu Chung Yau on 6/22/17.
//  Copyright © 2017 Yiu Chung Yau. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
class User{
    struct user {
    static let name = ""
    static let trackNo = "0"
    static let Weight = "1"
    static let Primode = "2"
    static let Category = "3"
    static let Ncar = "4"
}

let defaults = UserDefaults.standard
//Setting
    
    func setUserName(_ userName:String){
        defaults.set(userName, forKey: user.name)
    }
    func setTrackNo(_ trackNum:Int){
        defaults.set(trackNum, forKey: user.trackNo)
    }
    func setWeight(_ userWeight:Double){
        defaults.set(userWeight, forKey: user.Weight)
    }

    func setPrimode(_ userPrimode:Int){
        defaults.set(userPrimode, forKey: user.Primode)
    }
    
    func setCategory(_ userCategory:String){
        defaults.set(userCategory, forKey: user.Category)
    }
    
    func setNcar(_ userNcar:Int){
        defaults.set(userNcar, forKey: user.Ncar)
    }
    
   
    
// Getting
    func getUserName()->String{
        if let stringOne = defaults.string(forKey: user.name){
            return stringOne // Some String Value
        }else{
            return ""
        }
        
    }
    
    func getTrackNo()->String{
        if let stringTwo = defaults.string(forKey: user.trackNo){
            return stringTwo // Another String Value
        }else{
            return ""
        }
    }
    
    func getWeight()->String{
        if let st3 = defaults.string(forKey: user.Weight){
            return st3
        }
        else{
            return "0"
        }
    }

    func getPrimode()->String{
        if let string4 = defaults.string(forKey: user.Primode){
            return string4 // Another String Value
        }
        else{
            return ""
        }
    }
    
    func getCategory()->String{
        if let string5 = defaults.string(forKey: user.Category){
            return string5 // Another String Value
        }
        else{
            return ""
        }
    }
    
    func getNcar()->String{
        if let string6 = defaults.string(forKey: user.Ncar){
            return string6 // Another String Value
        }
        else{
            return ""
        }
    }
    
    
    
    
    
    
    
    
// Reset
    func reset(){
        defaults.set("", forKey: user.name)
        defaults.set("0", forKey: user.trackNo)
        defaults.set("0", forKey: user.Weight)
        defaults.set("0",forKey:user.Primode)
        defaults.set("",forKey:user.Category)
        defaults.set("0",forKey:user.Ncar)
    }

}


