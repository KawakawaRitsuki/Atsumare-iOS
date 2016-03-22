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
    
    var myId = ""
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var mMarker = Dictionary<Int, MKPointAnnotation>()
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var location:Location!

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "集まれ！"
        myId = appDelegate.myId
        
        appDelegate.isMap = true
        
        let leftBarButton = UIBarButtonItem(title: "ログアウト", style: .Plain, target: self, action: "back")
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        location = Location(myId: appDelegate.myId,groupId: appDelegate.groupId){(name: String,lon: Double,lat: Double,login: Int,id: Int) -> () in
            if (self.mMarker[id] == nil){
                if (login == 0){
                    let mapPoint : CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat,lon)
                    self.mMarker[id] = MKPointAnnotation()
                    self.mMarker[id]!.coordinate  = mapPoint
                    self.mMarker[id]!.title       = name
                    self.mapView.addAnnotation(self.mMarker[id]!)
                }
            }else{
                if(login==0){
                    let mapPoint : CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat,lon)
                    self.mMarker[id]!.coordinate  = mapPoint
                    self.mapView.addAnnotation(self.mMarker[id]!)
                }else{
                    self.mapView.removeAnnotation(self.mMarker[id]!)
                }
            }
        }
        
    }
    
    func back() {
        //戻る処理的な何か
        let alertController = UIAlertController(title: "確認", message: "終了しますか？", preferredStyle: .Alert)
        let otherAction = UIAlertAction(title: "OK", style: .Default) {
            action in
            self.location.stopTimer()
            self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            if(ApiConnection.post("grouplogout", message: "{\"user_id\":\"" + self.myId + "\",\"group_id\":\"" + self.appDelegate.groupId + "\"}") == "1"){
                ApiConnection.post("setusing", message: "{\"group_id\":\"" + self.appDelegate.groupId + "\",\"using\":1}")
            }
            self.appDelegate.isMap = false //appDelegateの変数を操作
            self.location.stopLocationManager()
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .Cancel) {
            action in
        }
        
        alertController.addAction(otherAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func setMarker(name: String,lon: Double,lat: Double,login: Int,id: Int){
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}