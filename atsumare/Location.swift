//
//  LocationManager.swift
//  atsumare
//
//  Created by 五嶋 律樹 on 2016/03/21.
//  Copyright © 2016年 KawakawaPlanning. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import SwiftyJSON

class Location{
    
    var lm: CLLocationManager!
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    var myId = ""
    var groupId = ""
    var timer:NSTimer! = nil
    var mMarker = Dictionary<Int, MKPointAnnotation>()
    var call:(name: String,lon: Double,lat: Double,login: Int,id: Int) -> Void!
    
    
    init(myId: String,groupId:String,callback: (name: String,lon: Double,lat: Double,login: Int,id: Int) -> Void) {
        self.myId = myId
        lm = CLLocationManager()
        longitude = CLLocationDegrees()
        latitude = CLLocationDegrees()
        lm.delegate = self
        lm.requestAlwaysAuthorization()
        
        if #available(iOS 9.0, *) {
            lm.allowsBackgroundLocationUpdates = true
        }
        
        lm.startUpdatingLocation()
        
        call = callback
        timer = NSTimer.scheduledTimerWithTimeInterval(
            1.0,
            target:self,
            selector: Selector("tickTimer:"),
            userInfo: nil,
            repeats: true)
        
        timer.fire()
    }
    
    func tickTimer(timer: NSTimer) {
        var json = JSON.parse(ApiConnection.post("getlocate" , message: "{\"group_id\":\"" + groupId + "\"}"))
        for var i = 0; i < json["data"].count; i++ {
            call(name: json["data"][i]["user_name"].stringValue,lon: json["data"][i]["longitude"].doubleValue, lat: json["data"][i]["latitude"].doubleValue,login: json["data"][i]["login"].intValue,id: i)
        }
    }
    
    func stopTimer(){
        timer.invalidate()
    }
    
    func stopLocationManager(){
        lm.stopUpdatingLocation()
    }//setMarkerはリスナにスべき？
    
    func hogeMethod(callback: (String) -> Void) -> Void {
        
        let message = "ですね"
        sleep(1)
        
        // 処理が終わったら第3引数で受け取った関数を実行。今回はメッセージを渡す
        callback(message)
    }
}

extension Location: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        latitude = newLocation.coordinate.latitude
        longitude = newLocation.coordinate.longitude
        
        ApiConnection.post("regist", message: "{\"user_id\":\"\(myId)\",\"latitude\":\"\(latitude)\",\"longitude\":\"\(longitude)\"}");
        print("latiitude: \(latitude) , longitude: \(longitude)")
    }
    
    @objc func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("Error")
    }
    
}