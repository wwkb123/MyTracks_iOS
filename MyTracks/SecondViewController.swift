//
//  SecondViewController.swift
//  MyTracks
//
//  Created by Yiu Chung Yau on 6/21/17.
//  Copyright © 2017 Yiu Chung Yau. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation
import GooglePlaces
import GoogleMaps
import Firebase
import FirebaseDatabase
import UserNotifications

class SecondViewController: UIViewController,CLLocationManagerDelegate  {
    var tid=0
    @IBOutlet weak var loadingLabel2: UILabel!
    
    @IBOutlet weak var loadingLabel: UILabel!
  
    @IBOutlet weak var bulbLabel: UILabel!
    
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var cemissionLabel: UILabel!
    @IBOutlet weak var cavoidLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var avgMovingSpeed: UILabel!
    @IBOutlet weak var maxSpeedLabel: UILabel!
    @IBOutlet weak var movingLabel: UILabel!
    @IBOutlet weak var elevationGain: UILabel!
    @IBOutlet weak var elevation: UILabel!
    @IBOutlet weak var speed: UILabel!
  
    var timer2 : Timer? = Timer()
    var jsonString=""
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var avgSpeed: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var totalDistance: UILabel!
    var sec=0.0
    var zeroTime = TimeInterval()
    var timer : Timer = Timer()
    var camera=GMSCameraPosition()
    let locationManager = CLLocationManager()
    var Lati = 0.0
    var Longti = 0.0
    
    var co=0
    let userData=User()
    var ref:DatabaseReference!
    var databaseHandle:DatabaseHandle?

    
    override func viewDidLoad() {
        
        tid=Int(userData.getTrackNo()) ?? 0
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.requestWhenInUseAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        } else {
            print("Need to Enable Location")
        }
        
        // We cannot access the user's HealthKit data without specific permission.
//        getHealthKitPermission()
        
 
       
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
         ref = Database.database().reference()
        //     self.ref.child("user").setValue(["zz": "tommyyommt"])
        //    self.ref.child("user").setValue(["yy": "jj"])
        
        databaseHandle=ref?.child("user").child(userData.getUserName()).child("data").observe(.value, with: { (snapshot) in
            //print(snapshot.value as! String)
         
            if let result:String    = (snapshot.value as? String ?? "9999 9999 9999 9999 9999 9999"){
            let resultArr = result.components(separatedBy: " ")
                if (resultArr.count<6){
                    self.caloriesLabel.text="9999"
                    self.cemissionLabel.text="9999"
                    self.cavoidLabel.text="9999"
                    self.fatLabel.text="9999"
                    self.bulbLabel.text="9999"
                    
                    isLoadingHidden=true
                    self.loadingLabel.isHidden=isLoadingHidden
                    self.loadingLabel2.isHidden=isLoadingHidden
                    
                    if(isCurrClicked){
                    
                    let delegate = UIApplication.shared.delegate as? AppDelegate
                    delegate?.notic()
                    
                    let alert = UIAlertController(title: "Message", message: "The calculation is finished, please check it", preferredStyle: UIAlertControllerStyle.alert)
                    
                   
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                        
                        isCurrClicked=false
                    }
                }
                else{
            let time    = resultArr[0]
            let cemission = resultArr[1]
            let cavoid = resultArr[2]
            let calories = resultArr[3]
            let fat = resultArr[4]
            let bulb = resultArr[5]
            print(resultArr)
            
            self.caloriesLabel.text=calories
            self.cemissionLabel.text=cemission
            self.cavoidLabel.text=cavoid
            self.fatLabel.text=fat
            self.bulbLabel.text=bulb
                    isLoadingHidden=true
                    self.loadingLabel.isHidden=isLoadingHidden
                    self.loadingLabel2.isHidden=isLoadingHidden
                    if(isCurrClicked){
                    let delegate = UIApplication.shared.delegate as? AppDelegate
                    delegate?.notic()
                    
                    let alert = UIAlertController(title: "Message", message: "The calculation is finished, please check it", preferredStyle: UIAlertControllerStyle.alert)
                    
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                        
                    isCurrClicked=false
                    }
                }

            }
        })
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        loadingLabel.isHidden=isLoadingHidden
        loadingLabel2.isHidden=isLoadingHidden
        print(isLoadingHidden)
        
        tid=Int(userData.getTrackNo())!
        super.viewWillAppear(animated)
        
        
         if(didRecord==true){
        timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SecondViewController.getTime), userInfo: nil, repeats: true)
        }else{
            timer2?.invalidate()
            timer2 = nil
            let defaults = UserDefaults.standard
            if let myarray = defaults.stringArray(forKey: "track"+String(tid)){
            print(myarray)
            print("track"+String(tid))
            
            speed.text=myarray[0]
            totalDistance.text=myarray[1]
            maxSpeedLabel.text=myarray[2]
            totalTime.text=myarray[3]
            avgSpeed.text=myarray[4]
            movingLabel.text=myarray[5]
            avgMovingSpeed.text=myarray[6]
            }
        }
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

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        print("hello2")
//        if startLocation == nil {
//            startLocation = locations.first as CLLocation!
//        } else {
//            let lastDistance = lastLocation.distance(from: locations.last as CLLocation!)
//            distanceTraveled += (lastDistance / 1000.0)
//            distanceString=distanceTraveled
//            
//            let trimmedDistance = String(format: "%.2f", distanceTraveled)
//            
//            totalDistance.text = "\(trimmedDistance) km"
//        }
//        
//        lastLocation = locations.last as CLLocation!
//    }
    
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
//                self.avgSpeed.text = heightString
//            })
//        })
//        
//    }
//    
//    @IBAction func share(_ sender: AnyObject) {
//        healthManager.saveDistance(distanceTraveled, date: Date())
//    }
    
    
    
    
    //The function below is for testing
    @IBAction func onClickPost(_ sender: UIButton) {

        co+=1
        // prepare json data
        //let json: [String: Any] = ["user":["username": "shenkk","weight":"111","primode":"1","regid":"67578","ncar":"1" ]]
        let json1 : [String:Any]=["userid":"tommyios4","trackid":"1","name":"asd","desc":"1","category":"subway","weight":"123","primode":"1","ncar":"1","startpid":"1","startwid":"0","endwid":"0","endpid":"1"]
                                 
        let json2:[Any]=[["wid":"1","name":"asdd","category":"subway","lon":co,"lat":"111","desc":"1","updated":"1"]]
        
        let json3:[Any]=[["pid":co,"lon":co,"lat":"111","accuracy":"1","bearing":"1","time":"1","speed":"1","altitude":"1","nsat":"1","x":"1","y":"1","z":"1"]]
        let json:[String:Any]=["track":json1,"waypoints":json2,"points":json3]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
       //let url = URL(string: "http://gongcloud.hunter.cuny.edu/upload/service.asmx/addNewUserGCM")!
        let url=URL(string:"http://gongcloud.hunter.cuny.edu/upload/service.asmx/processPost2")!
        var request = URLRequest(url: url)
        request.addValue( "application/json", forHTTPHeaderField:"Accept")
        request.addValue( "application/json; charset=utf-8", forHTTPHeaderField:"Content-type")
        request.addValue( "no-cache", forHTTPHeaderField:"Cache-control")
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                                print("response = \(String(describing: response ?? response))")
                            }
        }
        
        task.resume()
   
    }
//    @IBAction func leftClick(_ sender: UIButton) {
//        performSegue(withIdentifier: "btn2", sender: self)
//
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destVC=segue.destination as! ViewController
//        destVC.lati=Lati
//        destVC.longti=Longti
//        destVC.isRecord=isRecord
//    }
    
    func getTime(){
        totalTime.text=timeString
        totalDistance.text=String(format: "%.2f", distanceTraveled) + " km"
        speed.text=speedString
        avgSpeed.text=speedString
        movingLabel.text=movingTimeString
        if(movingTime<10){
            maxSpeedLabel.text="Waiting for stable speed..."
        }else{
            maxSpeedLabel.text=String(format: "%.0f", maxSpeed) + " km/h"
        }
        
        avgMovingSpeed.text=String(format: "%.0f", avgMovSpeed) + " km/h"
    }
@IBAction func onCurrClick(_ sender: Any) {
    
    
    isCurrClicked=true
    
    
    
   // ref = Database.database().reference()
       //  self.ref.child("user").child(userData.getUserName()).setValue(["data": "123 321 666 321 123 321"])
    print("Curr clicked")
    isLoadingHidden=false
    loadingLabel.isHidden=isLoadingHidden
    loadingLabel2.isHidden=isLoadingHidden

    let json = "?aUsername="+userData.getUserName()+"&aWeight="+String(userData.getWeight())+"&aPrimode="+String(userData.getPrimode())+"&aNCar="+String(userData.getNcar())
    
    let url2=URL(string:"http://gongcloud.hunter.cuny.edu/arcgis/rest/services/ModeDetection/ModeDetectionOnDemand/GPServer/Mode%20Detection%20on%20Demand/submitJob"+json)!
    print(url2)
    
    var request=URLRequest(url:url2)
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-type")
    
    request.httpMethod = "POST"
    // let jsonData = try? JSONSerialization.data(withJSONObject: json)
    print("json ok")
    //   request.httpBody = jsonData
    request.httpBody=json.data(using: String.Encoding.utf8)
    print(request.httpBody ?? "default")
    print("body ok")
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data")
            return
        }
        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
        if let responseJSON = responseJSON as? [String: Any] {
            print(responseJSON)
        }
        
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {          //  check for http errors
            print("statusCode should be 200, but is \(httpStatus.statusCode)")
            print("response = \(String(describing: response ?? response))")
        }
    }
    
    task.resume()
    

    
    }


    @IBAction func onPrevClick(_ sender: UIButton) {
        print("Prev clicked")
        
        //finding the date of yesterday
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M d"
        
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())
        print(yesterday ?? "default value")
       let dateString = dateFormatter.string(from: yesterday!)
        print(dateString)
        let dateArr = dateString.components(separatedBy: " ")
        let month=dateArr[0]
        let day=dateArr[1]
        
        let prefix="_"+month+"_"+day+"_"
        
        
        //let json:[String:Any]=["userid":userData.getUserName(),"prefix":prefix]
        let json="{\"userid\":\""+userData.getUserName()+"\",\"prefix\":\""+prefix+"\"} "
        print(json)
        let url2=URL(string:"http://gongcloud.hunter.cuny.edu/upload/Service.asmx/getPrevStat")!
     //   var request = HTTPURLResponse.init(url: url2, statusCode: 200, httpVersion: "", headerFields: ["Accept":"application/json","Content-type":"application/json charset=utf-8","Cache-control":"no-cache"])
        var request=URLRequest(url:url2)
            request.addValue( "application/json", forHTTPHeaderField:"Accept")
            request.addValue( "application/json; charset=utf-8", forHTTPHeaderField:"Content-type")
            request.addValue( "no-cache", forHTTPHeaderField:"Cache-control")
        
           request.httpMethod = "POST"
        // let jsonData = try? JSONSerialization.data(withJSONObject: json)
            print("json ok")
         //   request.httpBody = jsonData
            request.httpBody=json.data(using: String.Encoding.utf8)
            print(request.httpBody ?? "default")
            print("body ok")
         let task = URLSession.shared.dataTask(with: request) { data, response, error in
         guard let data = data, error == nil else {
         print(error?.localizedDescription ?? "No data")
         return
         }
         let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
         if let responseJSON = responseJSON as? [String: Any] {
         print(responseJSON)
         var result=""
         //var resultArr=["N/A", "N/A", "N/A", "N/A", "N/A"]
         result = responseJSON["d"] as! String
            let currTime=Date().timeIntervalSince1970 * 1000
            self.ref = Database.database().reference()
            let dataValue=String(Int64(currTime))+" "+result
            self.ref.child("user").child(self.userData.getUserName()).setValue(["data": dataValue])
            let resultString=result.trimmingCharacters(in: .whitespacesAndNewlines)

            if (resultString.characters.count==0){
                //resultArr=["N/A", "N/A", "N/A", "N/A", "N/A"]
                self.ref.child("user").child(self.userData.getUserName()).setValue(["data": String(Int64(currTime))+" "+"N/A N/A N/A N/A N/A"])
            }
//            else{
//            resultArr = result.components(separatedBy: " ")
//            }
//            let cemission = resultArr[0]
//            let cavoid = resultArr[1]
//            let calories = resultArr[2]
//            let fat = resultArr[3]
//            let bulb = resultArr[4]
//            
//            self.caloriesLabel.text=calories
//            self.cemissionLabel.text=cemission
//            self.cavoidLabel.text=cavoid
//            self.fatLabel.text=fat
//            self.bulbLabel.text=bulb
            print("finished")
         }
            
            
            
         if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {          //  check for http errors
         print("statusCode should be 200, but is \(httpStatus.statusCode)")
         print("response = \(String(describing: response ?? response))")
         }
         }
         
         task.resume()
    }
}

