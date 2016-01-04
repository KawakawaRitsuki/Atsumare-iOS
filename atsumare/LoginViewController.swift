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
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
        
        self.twLoginView.logInCompletion = {(session, error) in
            if let unwrappedSession = session {
                var str = self.post("twittercheck",message: "{\"user_id\":\"" + "tw_" + unwrappedSession.userName + "\"}")
                print(str)
                if str == "0"{
                    let targetViewController = self.storyboard!.instantiateViewControllerWithIdentifier( "GroupSelectStoryBoard" ) as! UIViewController
                    self.presentViewController( targetViewController, animated: true, completion: nil)
                }else{
                    //登録されてねえ
                }
            } else {
                NSLog("Login error: %@", error!.localizedDescription);
            }
        }


    }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if ((error) != nil)
        {
            //エラー処理
        }
        else if result.isCancelled {
            //キャンセル処理
        }
        else {
            if post("twittercheck",message: "{\"user_id\":\"" + "fb_" + result.token.userID + "\"}") == "Optional(0)"{
                defaults.setObject("fb_" + result.token.userID, forKey: "myId")
                let targetViewController = self.storyboard!.instantiateViewControllerWithIdentifier( "GroupSelectStoryBoard" ) as! UIViewController
                self.presentViewController( targetViewController, animated: true, completion: nil)
            }else{
                //登録されてねえ
            }
            
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("Userログアウト")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    @IBAction func loginBtnHandler(sender: AnyObject) {
//        print(post("login",message: "{\"user_id\":\"" + idTextField.text! + "\",\"password\":\"" + pwTextField.text! + "\"}"))
//    }

    func post( url:String , message: String) -> (String){
        // まずPOSTで送信したい情報をセット。
        let strData = message.dataUsingEncoding(NSUTF8StringEncoding)
        
        let url_ = NSURL(string: "http://kawakawaplanning.dip.jp:8080/"+url)
        var request = NSMutableURLRequest(URL: url_!)
        
        // この下二行を見つけるのに、少々てこずりました。
        request.HTTPMethod = "POST"
        request.HTTPBody = strData
        
        do {
            let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            print(data)
            let str = String(NSString(data:data, encoding:NSUTF8StringEncoding))
            return str
        } catch (let e) {
            print(e)
        }
        return ""
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
