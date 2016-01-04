//
//  ViewController.swift
//  atsumare
//
//  Created by KawakawaPlanning on 2016/01/01.
//  Copyright © 2016年 KawakawaPlanning. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate  {

    // 現在地の位置情報の取得にはCLLocationManagerを使用
    var lm: CLLocationManager!
    // 取得した緯度を保持するインスタンス
    var latitude: CLLocationDegrees!
    // 取得した経度を保持するインスタンス
    var longitude: CLLocationDegrees!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // フィールドの初期化
        lm = CLLocationManager()
        longitude = CLLocationDegrees()
        latitude = CLLocationDegrees()
        
        // CLLocationManagerをDelegateに指定
        lm.delegate = self
        
        // 位置情報取得の許可を求めるメッセージの表示.必須.
        lm.requestAlwaysAuthorization()
        // 位置情報の精度を指定.任意,
        // lm.desiredAccuracy = kCLLocationAccuracyBest
        // 位置情報取得間隔を指定.指定した値(メートル)移動したら位置情報を更新する.任意.
        // lm.distanceFilter = 1000
        if #available(iOS 9.0, *) {
            lm.allowsBackgroundLocationUpdates = true
        }
        
        // GPSの使用を開始する
        lm.startUpdatingLocation()
    }
    
    /* 位置情報取得成功時に実行される関数 */
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        // 取得した緯度がnewLocation.coordinate.longitudeに格納されている
        latitude = newLocation.coordinate.latitude
        // 取得した経度がnewLocation.coordinate.longitudeに格納されている
        longitude = newLocation.coordinate.longitude
        // 取得した緯度・経度をLogに表示
        
        post("latiitude: \(latitude) , longitude: \(longitude)")
        NSLog("latiitude: \(latitude) , longitude: \(longitude)")
        
        // GPSの使用を停止する.停止しない限りGPSは実行され,指定間隔で更新され続ける.
        // lm.stopUpdatingLocation()
    }
    
    /* 位置情報取得失敗時に実行される関数 */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        // この例ではLogにErrorと表示するだけ.
        NSLog("Error")
    }

    func post(let str: String){
        // まずPOSTで送信したい情報をセット。
        let strData = str.dataUsingEncoding(NSUTF8StringEncoding)
        
        let url = NSURL(string: "http://192.168.43.115:8080/post")
        var request = NSMutableURLRequest(URL: url!)
        
        // この下二行を見つけるのに、少々てこずりました。
        request.HTTPMethod = "POST"
        request.HTTPBody = strData
        
        do {
            let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        } catch (let e) {
            print(e)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}