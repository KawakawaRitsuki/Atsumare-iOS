//
//  AppDelegate.swift
//  atsumare
//
//  Created by KawakawaPlanning on 2016/01/01.
//  Copyright © 2016年 KawakawaPlanning. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Fabric
import TwitterKit
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isMap = false
    var myId = ""
    var groupId = ""

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.with([Crashlytics.self, Twitter.self])
        // Override point for customization after application launch.
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(
                application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        if(isMap){
            if(self.post("grouplogout", message: "{\"user_id\":\"" + self.myId + "\",\"group_id\":\"" + self.groupId + "\"}") == "1"){
                self.post("setusing", message: "{\"group_id\":\"" + self.groupId + "\",\"using\":1}")
            }
        }
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    func post( url:String , message: String) -> (String){
        // まずPOSTで送信したい情報をセット。
        let strData = message.dataUsingEncoding(NSUTF8StringEncoding)
        
        let url_ = NSURL(string: "http://kawakawaplanning.dip.jp:8080/"+url)
        let request = NSMutableURLRequest(URL: url_!)
        
        // この下二行を見つけるのに、少々てこずりました。
        request.HTTPMethod = "POST"
        request.HTTPBody = strData
        
        do {
            let data:NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let str = NSString(data:data, encoding:NSUTF8StringEncoding)
            return str as! String
        } catch (let e) {
            print(e)
        }
        return ""
    }

}

