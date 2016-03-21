//
//  Atsumare.swift
//  atsumare
//
//  Created by 五嶋 律樹 on 2016/03/21.
//  Copyright © 2016年 KawakawaPlanning. All rights reserved.
//API仕様書さくっと

import Foundation

class ApiConnection {
    
    static func post( url:String , message: String) -> (String){
        let strData = message.dataUsingEncoding(NSUTF8StringEncoding)
        
        let url_ = NSURL(string: "http://kawakawaplanning.dip.jp:8080/"+url)
        let request = NSMutableURLRequest(URL: url_!)
        
        request.HTTPMethod = "POST"
        request.HTTPBody = strData
        
        do {
            let data:NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            print(data)
            let str = NSString(data:data, encoding:NSUTF8StringEncoding)
            return str as! String
        } catch (let e) {
            print(e)
        }
        return ""
    }
    
    static func get(url:String) -> (String){

        let url_ = NSURL(string: "http://kawakawaplanning.dip.jp:8080/"+url)
        let request = NSMutableURLRequest(URL: url_!)
        
        do {
            let data:NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            print(data)
            let str = NSString(data:data, encoding:NSUTF8StringEncoding)
            return str as! String
        } catch (let e) {
            print(e)
        }
        return ""
    }
    
}