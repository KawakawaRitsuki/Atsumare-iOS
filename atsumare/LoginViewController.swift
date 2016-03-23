//
//  LoginViewController.swift
//  atsumare
//
//  Created by KawakawaPlanning on 2016/01/03.
//  Copyright © 2016年 KawakawaPlanning. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit

class LoginViewController: UIViewController ,FBSDKLoginButtonDelegate{

    @IBOutlet var fbLoginView : FBSDKLoginButton!
    @IBOutlet var twLoginView : TWTRLogInButton!
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "集まれへようこそ！"
    
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
        
        self.twLoginView.logInCompletion = {(session, error) in
            if let unwrappedSession = session {
                if ApiConnection.post("twittercheck",message: "{\"user_id\":\"" + "tw_" + unwrappedSession.userName + "\"}") == "0"{
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        sleep(1)
                        dispatch_async(dispatch_get_main_queue(), {

                            self.appDelegate.myId = "tw_" + unwrappedSession.userName
                            self.performSegueWithIdentifier("toSelect",sender: nil)
                        });
                    });
                    
                }else{
                    //未登録
                }
            } else {
                NSLog("Login error: %@", error!.localizedDescription);
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
//        let view = twLoginView.subviews.last!
//        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height + 400)
//        twLoginView.transform = CGAffineTransformMakeScale(1.0, 2.0)
        /*
        twLoginView.layer.borderWidth = 5.0
        twLoginView.layer.borderColor = UIColor(red:0.114,green:0.631,blue:0.949,alpha:1.0).CGColor
        
        fbLoginView.layer.borderWidth = 6.0
        fbLoginView.layer.borderColor = UIColor(red:0.255,green:0.365,blue:0.682,alpha:1.0).CGColor
*/
    }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if ((error) != nil){
            //エラー処理
        } else if result.isCancelled {
            //キャンセル処理
        } else {
            if ApiConnection.post("twittercheck",message: "{\"user_id\":\"" + "fb_" + result.token.userID + "\"}") == "0"{
                appDelegate.myId = "fb_" + result.token.userID
                
                self.performSegueWithIdentifier("toSelect",sender: nil)
            }else{
                //未登録
            }
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toSelect" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! SelectGroupViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true

        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("Userログアウト")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
