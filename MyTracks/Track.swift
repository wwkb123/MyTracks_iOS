//
//  Tracks.swift
//  MyTracks
//
//  Created by Yiu Chung Yau on 7/14/17.
//  Copyright © 2017 Yiu Chung Yau. All rights reserved.
//

import Foundation

class Track{
   
   static var Ttid=0
    var Tspeed=""
    var TtotalDistance=""
    var TmaxSpeed=""
    var TtotalTime=""
    var TavgSpeed=""
    var TmovingTime=""
    var TavgMovingSpeed=""
    var Televation=""
    var TelevGain=""
    
    
    //setting
    
    func setTid(_ id: Int){
        Track.Ttid=id
    }
    
    func setSpeed(_ tspeed:String){
        Tspeed=tspeed
    }
    
    func setTotalDistance(_ ttotaldistance:String){
        TtotalDistance=ttotaldistance
    }
    
    func setMaxSpeed(_ tmaxspeed:String){
        TmaxSpeed=tmaxspeed
    }
    func setTotalTime(_ ttotaltime:String){
        TtotalTime=ttotaltime
    }
    
    func setAvgSpeed(_ tavgspeed:String){
        TavgSpeed=tavgspeed
    }
    
    func setMovingTime(_ tmovingtime:String){
        TmovingTime=tmovingtime
    }
    
    func setAvgMovingSpeed(_ tavgmovingspeed:String){
        TavgMovingSpeed=tavgmovingspeed
    }
    
    func setElevation(_ televation:String){
        Televation=televation
    }
    
    func setElevGain(_ televgain:String){
        TelevGain=televgain
    }
    
    
    
    //getting
    
    func getTid()->Int{
         return Track.Ttid
    }
    
    func getSpeed()->String{
         return Tspeed
    }
    
    func getTotalDistance()->String{
         return TtotalDistance
    }
    
    func getMaxSpeed()->String{
        return TmaxSpeed
    }
    func getTotalTime()->String{
         return TtotalTime
    }
    
    func getAvgSpeed()->String{
         return TavgSpeed
    }
    
    func getMovingTime()->String{
         return TmovingTime
    }
    
    func getAvgMovingSpeed()->String{
         return TavgMovingSpeed
    }
    
    func getElevation()->String{
         return Televation
    }
    
    func getElevGain()->String{
         return TelevGain
    }
    
}
