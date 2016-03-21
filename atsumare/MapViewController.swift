//
//  ViewController.swift
//  atsumare
//
//  Created by KawakawaPlanning on 2016/01/01.
//  Copyright © 2016年 KawakawaPlanning. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SwiftyJSON

class MapViewController: UIViewController {

    var lm: CLLocationManager!
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    var myId: String = ""
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var timer:NSTimer! = nil
    var mMarker = Dictionary<Int, MKPointAnnotation>()
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "集まれ！"
        myId = appDelegate.myId
        
        appDelegate.isMap = true
        
        let leftBarButton = UIBarButtonItem(title: "ログアウト", style: .Plain, target: self, action: "back")
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        lm = CLLocationManager()
        longitude = CLLocationDegrees()
        latitude = CLLocationDegrees()
        lm.delegate = self
        lm.requestAlwaysAuthorization()
        
        if #available(iOS 9.0, *) {
            lm.allowsBackgroundLocationUpdates = true
        }
        
        lm.startUpdatingLocation()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(
            1.0,
            target:self,
            selector: Selector("tickTimer:"),
            userInfo: nil,
            repeats: true)
        
        timer.fire()
    }
    
    func back() {
        //戻る処理的な何か
        let alertController = UIAlertController(title: "確認", message: "終了しますか？", preferredStyle: .Alert)
        let otherAction = UIAlertAction(title: "OK", style: .Default) {
            action in
            self.timer.invalidate()
            self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            if(ApiConnection.post("grouplogout", message: "{\"user_id\":\"" + self.myId + "\",\"group_id\":\"" + self.appDelegate.groupId + "\"}") == "1"){
                ApiConnection.post("setusing", message: "{\"group_id\":\"" + self.appDelegate.groupId + "\",\"using\":1}")
            }
            self.appDelegate.isMap = false //appDelegateの変数を操作
            self.lm.stopUpdatingLocation()
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .Cancel) {
            action in
        }
        
        alertController.addAction(otherAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // タイマー処理
    func tickTimer(timer: NSTimer) {//ここのtimerには生成元のtimerが入ってるっぽい
        var json = JSON.parse(ApiConnection.post("getlocate" , message: "{\"group_id\":\"" + appDelegate.groupId + "\"}"))
        for var i = 0; i < json["data"].count; i++ {
            setMarker(json["data"][i]["user_name"].stringValue,lon: json["data"][i]["longitude"].doubleValue, lat: json["data"][i]["latitude"].doubleValue,login: json["data"][i]["login"].intValue,id: i)
        }
    }
    
    func setMarker(name: String,lon: Double,lat: Double,login: Int,id: Int){
        if (mMarker[id] == nil){
            if (login == 0){
                let mapPoint : CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat,lon)
                mMarker[id] = MKPointAnnotation()
                mMarker[id]!.coordinate  = mapPoint
                mMarker[id]!.title       = name
                mapView.addAnnotation(mMarker[id]!)
            }
        }else{
            if(login==0){
                let mapPoint : CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat,lon)
                mMarker[id]!.coordinate  = mapPoint
                mapView.addAnnotation(mMarker[id]!)
            }else{
                mapView.removeAnnotation(mMarker[id]!)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MapViewController :CLLocationManagerDelegate{
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        latitude = newLocation.coordinate.latitude
        longitude = newLocation.coordinate.longitude
        
        ApiConnection.post("regist", message: "{\"user_id\":\"\(myId)\",\"latitude\":\"\(latitude)\",\"longitude\":\"\(longitude)\"}");
        print("latiitude: \(latitude) , longitude: \(longitude)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("Error")
    }
    
}