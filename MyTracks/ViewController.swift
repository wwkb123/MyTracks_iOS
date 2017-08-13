//
//  ViewController.swift
//  MyTracks
//
//  Created by Yiu Chung Yau on 6/20/17.
//  Copyright © 2017 Yiu Chung Yau. All rights reserved.
//

import UIKit
import UserNotifications
import GoogleMaps
import CoreMotion
import Firebase
import FirebaseDatabase
var appDelegate = UIApplication.shared.delegate as! AppDelegate
var didRecord = appDelegate.isRecord
var timeString = appDelegate.timeString
var distanceTraveled = appDelegate.distanceString
var speedString = appDelegate.speedString
var startLocation = appDelegate.startLocation
var lastLocation = appDelegate.lastLocation
var lat=appDelegate.lat
var lon=appDelegate.lon
var track_x=appDelegate.track_x
var track_y=appDelegate.track_y
var track_z=appDelegate.track_z
var lastLat=appDelegate.lastLat
var lastLon=appDelegate.lastLon
var movingTime=appDelegate.movingTime
var movingTimeString=appDelegate.movingTimeString
var maxSpeed=appDelegate.maxSpeed
var avgMovSpeed=appDelegate.avgMovSpeed
var countGPS=0
var isLoadingHidden=appDelegate.isLoadingHidden
var isCurrClicked=appDelegate.isCurrClicked

class ViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    
    @IBAction func logout(_ sender: Any) {
        let alert = UIAlertController(title: "Message", message: "If you have any questions or problems, please contact us at gpstrackshunter@gmail.com", preferredStyle: UIAlertControllerStyle.alert)
        
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
//            print("OK")
//            self.userData.reset()
//        }))
//        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(alert, animated: true, completion: nil)
    }
    @IBAction func p7Click(_ sender: UIButton) {
        page7.isHidden=true
    }
   
    @IBAction func p6Click(_ sender: UIButton) {
        page6.isHidden=true
    }
    @IBAction func p5Click(_ sender: UIButton) {
        page5.isHidden=true
    }
    
    @IBAction func p4Click(_ sender: UIButton) {
        page4.isHidden=true
    }
    @IBAction func p3Click(_ sender: UIButton) {
        page3.isHidden=true
    }
    
    @IBAction func p2Click(_ sender: UIButton) {
        page2.isHidden=true
    }
    
    @IBAction func p1Click(_ sender: UIButton) {
        page1.isHidden=true
    }
    @IBOutlet weak var page2: UIView!
    @IBOutlet weak var page5: UIView!
    
    @IBOutlet weak var page7: UIView!
    @IBOutlet weak var page6: UIView!
    @IBOutlet weak var page3: UIView!
    @IBOutlet weak var page4: UIView!
    @IBOutlet weak var ncarText: UITextField!
    @IBOutlet weak var weightText: UITextField!
    @IBOutlet weak var userText: UITextField!
    
   
    @IBOutlet weak var recordNcarText: UITextField!
    @IBOutlet weak var recordWeightLabel: UITextField!
    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var page1: UIView!
    @IBOutlet weak var recordButton: UIButton!
    

    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    
    //data for json
   
    let userData=User()
    var pointId=0
    var tid=0
    var userid=""
   
    var primode = 0 //primode for register
    var regisWeight=0
    var recordPrimode=0 //primode for record
    var nsat=0
    var category=""
    @IBOutlet weak var recordSegCon: UISegmentedControl!
    var regisCategory=""
    var weight=0
    var ncar=0
    
    
    
    
    var json1 : [String:Any]=[:]
    var json2 : [Any]=[]
    var json3 : [Any]=[]
    
    
    
    var camera=GMSCameraPosition()
    let locationManager = CLLocationManager()
    var motionManager=CMMotionManager()
    let bgController =  BackgroundTaskController() //a class
    var timer3 : Timer? = Timer()
//    let healthManager:HealthKitManager = HealthKitManager()
    let path = GMSMutablePath() //path on the map
    var rectangle = GMSPolyline()
    @IBOutlet weak var regisView: UIView!
    @IBOutlet weak var leftview: UIView!
    var  mapView:GMSMapView?
    var isOpen=false
    var isSatellite=false
    @IBOutlet weak var satelliteMode: UIButton!
    @IBOutlet weak var menuBtn: UIButton!
    var lati = 40.758896
    var longti = -73.985130
    var overlay=GMSGroundOverlay()
    
    var ref:DatabaseReference!
    var databaseHandle:DatabaseHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tid=Int(userData.getTrackNo()) ?? 0
        userid=userData.getUserName() 
        primode=Int(userData.getPrimode()) ?? 0
        weight=Int(userData.getWeight()) ?? 0
        category=userData.getCategory() 
        recordPrimode=primode
        ncar=Int(userData.getNcar()) ?? 0
        isOpen=false
        
        
//        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
       
      
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        } else {
            print("Need to Enable Location")
        }
        
        // We cannot access the user's HealthKit data without specific permission.
       //bgController.getHealthKitPermission()
        locationManager.startUpdatingLocation()
        print(CLLocationManager.authorizationStatus())
        if(Int((locationManager.location?.horizontalAccuracy ?? 999)!)<100){
       lati=(self.locationManager.location?.coordinate.latitude)!
        longti=(self.locationManager.location?.coordinate.longitude)!
        }
        
        menuBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 30, 15, 90);
        let _camera = GMSCameraPosition.camera(withLatitude: lati, longitude:longti, zoom: 13.0)
        mapView = GMSMapView.map(withFrame: CGRect(x:100, y:100,width:self.view.frame.size.width,height:self.view.frame.size.height), camera: _camera)
        mapView?.center=self.view.center
        self.view.addSubview(mapView!)

        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = _camera.target
//        marker.snippet = "Current Location"
//        marker.map = mapView
        
        
        mapView?.settings.zoomGestures=true
        self.view.addSubview(mapView!)
        
        self.view.bringSubview(toFront: recordView)
        self.recordView.isHidden=true
        
        //checking whether the user has registered
        if(userid=="" || tid==0){
            self.view.bringSubview(toFront: regisView)
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.setNavigationBarHidden(true, animated:true)
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
            
            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            tap.cancelsTouchesInView = false
            
            view.addGestureRecognizer(tap)
            
            
        }
        if (Int((locationManager.location?.horizontalAccuracy ?? 999)!) < 100){
        overlay = GMSGroundOverlay.init(position: (self.locationManager.location?.coordinate)!, icon: #imageLiteral(resourceName: "arrow_40"), zoomLevel: 15.0)
        overlay.map=mapView
        }
        
        
        
        
        
        
        
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        motionManager.accelerometerUpdateInterval = 5  //get data from accelerometer every 5 seconds
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
           // print("hi moving")
            if let myData=data{
                track_x=myData.acceleration.x * 9.81   //9.81 is the gravitational pull on earth
                track_y=myData.acceleration.y * 9.81
                track_z=myData.acceleration.z * 9.81
            }
        }
        
        if(userid=="" || tid==0){
            print("new user")
        }
        else{
        ref = Database.database().reference()
        
        databaseHandle=ref?.child("user").child(userData.getUserName()).child("data").observe(.value, with: { (snapshot) in
            //print(snapshot.value as! String)
            
            if let result:String    = (snapshot.value as? String ?? "9999 9999 9999 9999 9999 9999"){
                let resultArr = result.components(separatedBy: " ")
                
                    
                    if(isCurrClicked && 1==0){
                        
                        let delegate = UIApplication.shared.delegate as? AppDelegate
                        delegate?.notic()
                        
                        let alert = UIAlertController(title: "Message", message: "The calculation is finished, please check it", preferredStyle: UIAlertControllerStyle.alert)
                        
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        isCurrClicked=false
                    }
            }
        })
        }
    }
    

    func showCurrentLocation(){
        
        if (Int((locationManager.location?.horizontalAccuracy ?? 999)!) < 100){
            let update = GMSCameraUpdate.setTarget((lastLocation?.coordinate)!) as GMSCameraUpdate?
            mapView?.moveCamera(update!)
        }else{
            let alert = UIAlertController(title: "Alert", message: "Cannot find location. GPS signal is too weak.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
        
        
    }
    @IBAction func menuClick(_ sender: UIButton) {
        if(isOpen==false){
        view.bringSubview(toFront: leftview)
            isOpen=true
        }else{
            view.sendSubview(toBack: leftview)
            isOpen=false
        }
    }
    
    @IBAction func myLocationClick(_ sender: UIButton) {
        showCurrentLocation()
    }
 @IBAction func satelliteClick(_ sender: UIButton) {
    if(isSatellite==false){
        mapView?.mapType = .satellite
        satelliteMode.setTitle("Map Mode", for: .normal)
        satelliteMode.setImage(#imageLiteral(resourceName: "icons8-map_marker_filled"), for: .normal)
        isSatellite=true 
        }else{
         mapView?.mapType = .normal
        satelliteMode.setTitle("Satellite Mode", for: .normal)
        satelliteMode.setImage(#imageLiteral(resourceName: "icons8-satellite_in_orbit_filled"), for: .normal)
        isSatellite=false
        }
}
//    @IBAction func rightClick(_ sender: UIButton) {
//        performSegue(withIdentifier: "btn", sender: self)
//    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destVC=segue.destination as! SecondViewController
//        destVC.Lati=lati
//        destVC.Longti=longti
//        destVC.isRecord=isRecord
//    }
    
    
    
    
    //start background task
    @IBAction func onRecordClick(_ sender: UIButton) {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        
        
        if (didRecord==false) {   //start recording
            
            self.recordView.isHidden=false
            self.view.bringSubview(toFront: recordView)
            self.view.sendSubview(toBack: leftview)
            recordWeightLabel.text=userData.getWeight()
            recordNcarText.text=userData.getNcar()
            recordSegCon.selectedSegmentIndex=Int(userData.getPrimode()) ?? 0
            locationManager.startUpdatingLocation()
            rectangle.map=nil
            path.removeAllCoordinates()
            mapView?.clear()
            
            
            
        } else {    //stop recording
            sender.setTitle("Start Recording", for: .normal)
            sender.setImage(#imageLiteral(resourceName: "icons8-record_filled"), for: .normal)
            didRecord=false
            
            
            let distanceString=String(format:"%0.2f",distanceTraveled)+" km"
            let maxSpeedString=String(format:"%0.2f",maxSpeed)+" km/h"
            let avgMovSpeedString=String(format:"%0.2f",avgMovSpeed)+" km/h"
            
            let array = [speedString,distanceString,maxSpeedString,timeString,speedString,movingTimeString,avgMovSpeedString]
            let defaults = UserDefaults.standard
            defaults.set(array, forKey: "track"+String(tid))
          
            let myarray = defaults.stringArray(forKey: "track"+String(tid)) ?? [String]()
            print(myarray)
            print("track"+String(tid))
            
            bgController.onStop()
            locationManager.stopUpdatingLocation()
            timer3?.invalidate()
            
            
        }
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if startLocation == nil {
            startLocation = locations.first as CLLocation!
        } else {
            let lastDistance = lastLocation?.distance(from: locations.last as CLLocation!)
            distanceTraveled += (lastDistance! / 1000.0)
            
        }
        
        lastLocation = locations.last as CLLocation!
        lastLat=lat
        lastLon=lon
        lat=(lastLocation?.coordinate.latitude)!*1E6
        lon=(lastLocation?.coordinate.longitude)!*1E6
        
        let update = GMSCameraUpdate.setTarget((lastLocation?.coordinate)!)

        
        
        
        
        
        
        //print(locationManager.allowsBackgroundLocationUpdates)
        //print(locationManager.location?.speed ?? "jj")
        if (locationManager.location!.speed>0.0 && didRecord==true){
            rectangle = GMSPolyline(path: path)
            rectangle.map = mapView
            var nowLat=(lastLocation?.coordinate.latitude)!
            var nowLon=(lastLocation?.coordinate.longitude)!
            let diffLat=((lastLocation?.coordinate.latitude)!-(lastLat/(1E6)))
            let diffLon=((lastLocation?.coordinate.longitude)!-(lastLon/(1E6)))
            nowLat+=diffLat
            nowLon+=diffLon
            //print(nowLon)
            movingTime+=1
            let hours = movingTime / 3600
            let minutes = (movingTime%3600)/60
            let seconds = movingTime-hours*3600-minutes*60
            let strHours = String(format: "%02d", hours)
            let strMinutes = String(format: "%02d", minutes)
            let strSeconds = String(format: "%02d", seconds)
            
            path.add(CLLocationCoordinate2D(latitude: nowLat, longitude: nowLon))
            
        
            movingTimeString = "\(strHours):\(strMinutes):\(strSeconds)"
            avgMovSpeed=(distanceTraveled*1000.0/Double(movingTime))*3.6
            overlay.position.latitude=nowLat
            overlay.position.longitude=nowLon
            mapView?.moveCamera(update)
        }
        
        
        
    }
    
    /************  upload data every 5 seconds ***************/
    
    func getPoint(){
        print("The acc is")
        print(locationManager.location?.horizontalAccuracy ?? 0)
//        if(locationManager.location?.horizontalAccuracy==nil){
//            nsat = (-1)
//            print("yeah")
//        }
       
    //    print("getPoint")
    //    print(lat)
       // print(lon)
        
        let status=Int((locationManager.location?.horizontalAccuracy ?? 999)!)  // current status of the accuracy of GPS, good for <100, bad for >100, use cell tower or wifi for 1414
        print("Status is")
        print(status)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateInFormat = dateFormatter.string(from: NSDate() as Date)
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
  
        
        print(userData.getUserName())
        print(userData.getTrackNo())
        print(ReachabilityManager.shared.reachability.isReachable)
        pointId+=1
        let currTime=Date().timeIntervalSince1970 * 1000

        
        //if there network connection is available
        print("nsat is")
        print(nsat)
        
//        if(ReachabilityManager.shared.reachability.isReachable==true){
        if(status<100 && ReachabilityManager.shared.reachability.isReachable==true){
        
        /*json1=["userid":userData.getUserName(),"trackid":userData.getTrackNo(),"name":"date","desc":"1","category":"subway","weight":"123","primode":"2","ncar":"1","startpid":"1","startwid":"0","endwid":"0","endpid":"1"]
        
            json2=[["wid":"1","name":"asdd","category":"subway","lon":Int(lon),"lat":Int(lat),"desc":"1","updated":"1"]]
        
        json3=[["pid":pointId,"lon":Int(lon),"lat":Int(lat),"accuracy":"1","bearing":"1","time":Int(currTime),"speed":"1","altitude":"1","nsat":nsat,"x":track_x,"y":track_y,"z":track_z]]
        
        */
            if(nsat == -2 || nsat == -1){
                nsat = 0
                json1=["userid":userData.getUserName(),"trackid":userData.getTrackNo(),"name":dateInFormat,"desc":"1","category":category,"weight":weight,"primode":primode,"ncar":ncar,"startpid":"1","startwid":"0","endwid":"0","endpid":"1"]
                
                json2+=[["wid":"1","name":"asdd","category":category,"lon":Int(lon),"lat":Int(lat),"desc":"1","updated":"1"]]
                
                json3+=[["pid":pointId,"lon":Int(lon),"lat":Int(lat),"accuracy":"1","bearing":"1","time":Int64(currTime),"speed":"1","altitude":"1","nsat":nsat,"x":track_x,"y":track_y,"z":track_z]]
            }
            else{
                json1=["userid":userData.getUserName(),"trackid":userData.getTrackNo(),"name":dateInFormat,"desc":"1","category":category,"weight":weight,"primode":primode,"ncar":ncar,"startpid":"1","startwid":"0","endwid":"0","endpid":"1"]
                
                json2=[["wid":"1","name":"asdd","category":category,"lon":Int(lon),"lat":Int(lat),"desc":"1","updated":"1"]]
                
                json3=[["pid":pointId,"lon":Int(lon),"lat":Int(lat),"accuracy":"1","bearing":"1","time":Int64(currTime),"speed":"1","altitude":"1","nsat":nsat,"x":track_x,"y":track_y,"z":track_z]]
            }
            
            
            
        let json:[String:Any]=["track":json1,"waypoints":json2,"points":json3]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
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
        //if no network, store the points in the phone
            
        else if(status==1414){  //getting location from cell tower or wifi
            
            nsat = (-2)
            print("here nsat is")
            print(nsat)
           
            
            json1=["userid":userData.getUserName(),"trackid":userData.getTrackNo(),"name":dateInFormat,"desc":"1","category":category,"weight":weight,"primode":primode,"ncar":ncar,"startpid":"1","startwid":"0","endwid":"0","endpid":"1"]
            
            json2+=[["wid":"1","name":"asdd","category":category,"lon":Int(lon),"lat":Int(lat),"desc":"1","updated":"1"]]
            
            json3+=[["pid":pointId,"lon":Int(lon),"lat":Int(lat),"accuracy":"1","bearing":"1","time":Int64(currTime),"speed":"1","altitude":"1","nsat":nsat,"x":track_x,"y":track_y,"z":track_z]]
            
        }
        
        else{  //no signal
            
            nsat = (-1)
            print("and here nsat is")
            print(nsat)
            
            json1=["userid":userData.getUserName(),"trackid":userData.getTrackNo(),"name":dateInFormat,"desc":"1","category":category,"weight":weight,"primode":primode,"ncar":ncar,"startpid":"1","startwid":"0","endwid":"0","endpid":"1"]
            
            json2+=[["wid":"1","name":"asdd","category":category,"lon":0,"lat":100000000,"desc":"1","updated":"1"]]
            
            json3+=[["pid":pointId,"lon":0,"lat":100000000,"accuracy":"1","bearing":"1","time":Int64(currTime),"speed":"1","altitude":"1","nsat":nsat,"x":track_x,"y":track_y,"z":track_z]]
            
            //100000000
            
            
        }
        
        
        

    }
    
 /********register***********/

    @IBAction func onResetClick(_ sender: UIButton) {
        userText.text=""
        weightText.text=""
        ncarText.text=""
    }
    @IBAction func onSubmitClick(_ sender: UIButton) {
        var isFinish=true
        var isValid=true
        let nameString=userText.text!
        let weightString=weightText.text!
        let ncarString=ncarText.text!
        
        
        
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        let characterset2 = CharacterSet(charactersIn: "0123456789")
        
        //checking invalid value
        if (nameString.rangeOfCharacter(from: characterset.inverted) != nil || nameString=="") {
            let alert = UIAlertController(title: "Alert", message: "Username cannot contains special characters or be empty", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            isValid=false
        }
        else if (weightString.rangeOfCharacter(from: characterset2.inverted) != nil || weightString=="") {
            let alert = UIAlertController(title: "Alert", message: "Weight contains only number and must be filled", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            isValid=false
        }
        else if (ncarString.rangeOfCharacter(from: characterset2.inverted) != nil || ncarString=="") {
            let alert = UIAlertController(title: "Alert", message: "Number of people contains only number and must be filled", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            isValid=false
        }
        
        
        if(isValid){
            
            var regisWeight=Int(weightString) ?? 0
            regisWeight=Int(weightString)!
            let regisNcar=Int(ncarString) ?? 0
            userData.setNcar(regisNcar)
            print(userText.text!)
            // prepare json data
            let json: [String: Any] = ["user":["username": nameString,"weight":regisWeight,"primode":primode,"regid":nameString,"ncar":regisNcar]]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)

            // create post request
            let url = URL(string: "http://gongcloud.hunter.cuny.edu/upload/service.asmx/addNewUserGCM")!
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
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response ?? response))")
                    isFinish=false
                    }
                if let responseJSON = responseJSON as? [String: Any] {
                    //if post successfully
                    print(responseJSON)
                    var success:Bool
                    success = responseJSON["d"] as! Bool
                    if(success==false){
                        isFinish=false
                    }
                    DispatchQueue.main.async {
                        self.checkIsFinish(isFinish)  //change the layout if finished
                    }
                }
                
            }
            task.resume()
        }
        
    }
    func checkIsFinish(_ isFinish:Bool){
        if(isFinish==true){
                self.registerFinish()
            }
            else{
                self.registerFail()
            }
    }
    func registerFinish(){
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated:true)
        self.regisView.isHidden=true
        userData.setUserName(userText.text!)
        userData.setTrackNo(1)
        userData.setWeight(Double(regisWeight))
        
        page1.isHidden=false
        page2.isHidden=false
        page3.isHidden=false
        page4.isHidden=false
        page5.isHidden=false
        page6.isHidden=false
        page7.isHidden=false
        
        self.view.bringSubview(toFront: page7)
        self.view.bringSubview(toFront: page6)
        self.view.bringSubview(toFront: page5)
        self.view.bringSubview(toFront: page4)
        self.view.bringSubview(toFront: page3)
        self.view.bringSubview(toFront: page2)
        self.view.bringSubview(toFront: page1)
    }
    
    
    func registerFail(){
        let alert = UIAlertController(title: "Alert", message: "The username is already exist or cannot connect to the server!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func segControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            primode=0
            regisCategory="car"
            userData.setPrimode(primode)
            userData.setCategory(regisCategory)
            print(regisCategory)
        case 1:
            primode=1
            regisCategory="bus"
            userData.setPrimode(primode)
            userData.setCategory(regisCategory)
            print(regisCategory)
        case 2:
            primode=2
            regisCategory="subway"
            userData.setPrimode(primode)
            userData.setCategory(regisCategory)
            print(regisCategory)
        case 3:
            primode=3
            regisCategory="rail"
            userData.setPrimode(primode)
            userData.setCategory(regisCategory)
            print(regisCategory)
        case 4:
            primode=4
            regisCategory="bicycle"
            userData.setPrimode(primode)
            userData.setCategory(regisCategory)
            print(regisCategory)
        case 5:
            primode=5
            regisCategory="walk"
            userData.setPrimode(primode)
            userData.setCategory(regisCategory)
            print(regisCategory)
        case 6:
            primode=6
            regisCategory="ferry"
            userData.setPrimode(primode)
            userData.setCategory(regisCategory)
            print(regisCategory)
        default:
            break;
        }
    }
    
    
    
    /******** record start **********/
    
    
    @IBAction func onRecordNoClick(_ sender: UIButton) {
        
        self.recordView.isHidden=true
        
    }
    @IBAction func onRecordYesClick(_ sender: UIButton) {
        
        var isValid=true
        let weightString=recordWeightLabel.text!
        let ncarString=recordNcarText.text!
        weight=Int(weightString) ?? 0
        ncar=Int(ncarString) ?? 0
        
        let characterset = CharacterSet(charactersIn: "0123456789")
        
        //checking invalid value
        if (weightString.rangeOfCharacter(from: characterset.inverted) != nil || weightString=="") {
            let alert = UIAlertController(title: "Alert", message: "Weight contains only number and must be filled", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            isValid=false
        }
        else if (ncarString.rangeOfCharacter(from: characterset.inverted) != nil || ncarString=="") {
            let alert = UIAlertController(title: "Alert", message: "Number of people contains only number and must be filled", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            isValid=false
        }
        
        
        if(isValid){
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateInFormat = dateFormatter.string(from: NSDate() as Date)
            let timeZone = TimeZone.autoupdatingCurrent.identifier as String
            dateFormatter.timeZone = TimeZone(identifier: timeZone)
          
            
            
            recordButton.setTitle("Stop Recording", for: .normal)
            recordButton.setImage(#imageLiteral(resourceName: "icons8-stop_filled"), for: .normal)
            userData.setNcar(ncar)
            userData.setWeight(Double(weight))
            print("Result:")
            print(userData.getNcar())
            print(userData.getWeight())
            self.recordView.isHidden=true
            didRecord=true
            pointId=0
            tid+=1
            primode=recordPrimode
            userData.setTrackNo(tid)
            let currTime=Date().timeIntervalSince1970 * 1000
            movingTime = 0
            movingTimeString="00:00:00"
            maxSpeed=0.0
            avgMovSpeed=0.0
            distanceTraveled=0.0
            locationManager.allowsBackgroundLocationUpdates=true
            bgController.onStart()
            
            json1=["userid":userData.getUserName(),"trackid":userData.getTrackNo(),"name":dateInFormat,"desc":"1","category":category,"weight":weight,"primode":primode,"ncar":ncar,"startpid":"1","startwid":"0","endwid":"0","endpid":"1"]
            
            json2=[["wid":"1","name":"asdd","category":category,"lon":Int(lon),"lat":Int(lat),"desc":"1","updated":"1"]]
            
            json3=[["pid":pointId,"lon":Int(lon),"lat":Int(lat),"accuracy":"1","bearing":"1","time":Int64(currTime),"speed":"1","altitude":"1","nsat":nsat,"x":track_x,"y":track_y,"z":track_z]]
            
            
            let distanceString=String(format:"%0.2f",distanceTraveled)+" km"
            let maxSpeedString=String(format:"%0.2f",maxSpeed)+" km/h"
            let avgMovSpeedString=String(format:"%0.2f",avgMovSpeed)+" km/h"
            
            let array = [speedString,distanceString,maxSpeedString,timeString,speedString,movingTimeString,avgMovSpeedString]
            let defaults = UserDefaults.standard
            defaults.set(array, forKey: "track"+String(tid))

            
            timer3 = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.getPoint), userInfo: nil, repeats: true)
            
            
            
            
        }
        
        
        
        
        
        
    }
    @IBAction func recordSeg(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            print("car")
            recordPrimode=0
            category="car"
            userData.setPrimode(recordPrimode)
            userData.setCategory(category)
        case 1:
            print("bus")
            recordPrimode=1
            category="bus"
            userData.setPrimode(recordPrimode)
            userData.setCategory(category)
        case 2:
            print("subway")
            recordPrimode=2
            category="subway"
            userData.setPrimode(recordPrimode)
            userData.setCategory(category)
        case 3:
            print("rail")
            recordPrimode=3
            category="rail"
            userData.setPrimode(recordPrimode)
            userData.setCategory(category)
        case 4:
            print("bicycle")
            recordPrimode=4
            category="bicycle"
            userData.setPrimode(recordPrimode)
            userData.setCategory(category)
        case 5:
            print("walk")
            recordPrimode=5
            category="walk"
            userData.setPrimode(recordPrimode)
            userData.setCategory(category)
        case 6:
            print("ferry")
            recordPrimode=6
            category="ferry"
            userData.setPrimode(recordPrimode)
            userData.setCategory(category)
        default:
            break;
        }

        
    }
}

