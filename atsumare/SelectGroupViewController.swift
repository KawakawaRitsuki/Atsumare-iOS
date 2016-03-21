//
//  SelectGroupViewController.swift
//  atsumare
//
//  Created by KawakawaPlanning on 2016/01/04.
//  Copyright © 2016年 KawakawaPlanning. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import FBSDKLoginKit

class SelectGroupViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var groupName: [String] = []
    var groupId: [String] = []
    var myId: String = ""
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "グループ選択"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do view setup here.
        
        let leftBarButton = UIBarButtonItem(title: "ログアウト", style: .Plain, target: self, action: "logout")
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "cellLongPressed:")
        self.tableView.addGestureRecognizer(longPressRecognizer)
        
        myId = appDelegate.myId
        load()
    }
    
    func load(){
        groupId.removeAll(keepCapacity: false)
        groupName.removeAll(keepCapacity: false)
        self.tableView.reloadData()
        let query = "{\"user_id\":\"" + myId + "\"}"
        let url:NSURL = NSURL(string:"http://kawakawaplanning.dip.jp:8080/getgroup")!
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        request.HTTPBody = query.dataUsingEncoding(NSUTF8StringEncoding)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response:NSURLResponse?, data:NSData?, error:NSError? ) in
                var json = JSON.parse( NSString(data: data!, encoding: NSUTF8StringEncoding)! as String )
                for var i = 0; i < json["data"].count; i++ {
                    self.groupName.append("\(json["data"][i]["group_name"])")
                    self.groupId.append("\(json["data"][i]["group_id"])")
                }
                self.tableView.reloadData()
        })
    }
    
    @IBAction func logout(){
        let alertController = UIAlertController(title: "確認", message: "本当にログアウトしてもいいですか？", preferredStyle: .Alert)
        let otherAction = UIAlertAction(title: "OK", style: .Default) {
            action in
            self.appDelegate.myId = ""
            self.dismissViewControllerAnimated(true, completion: nil)
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .Cancel) {
            action in print("Pushed CANCEL!")
        }
        
        alertController.addAction(otherAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func makeGroup(sender: AnyObject) {
        var groupNameTextField: UITextField?
        let alertController = UIAlertController(title: "グループ作成", message: "作成するグループ名を入力してください。", preferredStyle: .Alert)
        let otherAction = UIAlertAction(title: "OK", style: .Default) {
            action in
            
            
            let alertController1 = UIAlertController(title: "グループ作成", message: "グループの作成が完了しました。友達を早速誘おう！グループIDは「" + ApiConnection.post("makegroup", message: "{\"user_id\":\"" + self.myId + "\",\"group_name\":\"" + (groupNameTextField?.text)! + "\"}") + "」です。", preferredStyle: .Alert)
                self.load()
                print("{\"user_id\":\"" + self.myId + "\",\"group_name\":\"" + (groupNameTextField?.text)! + "\"}")
            let okAction = UIAlertAction(title: "OK", style: .Default) {
                action in
            }
            alertController1.addAction(okAction)
            self.presentViewController(alertController1, animated: true, completion: nil)
            
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .Cancel) {
            action in
        }
        
        alertController.addAction(otherAction)
        alertController.addAction(cancelAction)
        alertController.addTextFieldWithConfigurationHandler { textField -> Void in
            groupNameTextField = textField
            textField.placeholder = "グループ名"
        }
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func inGroup(sender: AnyObject) {
        var groupIDTextField: UITextField?
        let alertController = UIAlertController(title: "グループ参加", message: "参加したいグループIDを入力してください。", preferredStyle: .Alert)
        let otherAction = UIAlertAction(title: "OK", style: .Default) {
            action in
            print(ApiConnection.post("isgroup", message: "{\"user_id\":\"" + self.myId + "\",\"group_id\":\"" + (groupIDTextField?.text)! + "\"}"))
            if (ApiConnection.post("isgroup", message: "{\"user_id\":\"" + self.myId + "\",\"group_id\":\"" + (groupIDTextField?.text)! + "\"}") == "1") {
                if(ApiConnection.post("ingroup", message: "{\"user_id\":\"" + self.myId + "\",\"group_id\":\"" + (groupIDTextField?.text)! + "\"}") == "0"){
                    let alertController1 = UIAlertController(title: "グループ参加", message: "グループに参加しました。さっそくグループを選択して遊ぼう！", preferredStyle: .Alert)
                    self.load()
                    let okAction = UIAlertAction(title: "OK", style: .Default) {
                        action in
                    }
                    alertController1.addAction(okAction)
                    self.presentViewController(alertController1, animated: true, completion: nil)
                }else{
                    let alertController1 = UIAlertController(title: "エラー", message: "グループが見つかりませんでした。グループIDを確認してもう一度お試しください。", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Default) {
                        action in
                    }
                    alertController1.addAction(okAction)
                    self.presentViewController(alertController1, animated: true, completion: nil)
                }
            }else{
                let alertController1 = UIAlertController(title: "エラー", message: "このグループはすでに参加しています。", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default) {
                    action in
                }
                alertController1.addAction(okAction)
                self.presentViewController(alertController1, animated: true, completion: nil)

            }
            
            
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .Cancel) {
            action in
        }
        
        alertController.addAction(otherAction)
        alertController.addAction(cancelAction)
        alertController.addTextFieldWithConfigurationHandler { textField -> Void in
            groupIDTextField = textField
            textField.placeholder = "グループID"
        }
        presentViewController(alertController, animated: true, completion: nil)
    }

    // セルの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupName.count
    }
    
    // セルの内容を変更
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle ,reuseIdentifier: "Cell")
        cell.textLabel!.text = groupName[indexPath.row]
        cell.detailTextLabel!.text = "GroupID:" + groupId[indexPath.row]
        cell.backgroundColor = UIColor(red:1.0,green:0.98,blue:	0.875,alpha:1.0)
        return cell;
    }
    
    
    // セル選択リスナ
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        appDelegate.groupId = groupId[indexPath.row]
        self.performSegueWithIdentifier("toWait",sender: nil)
    }
    
    func cellLongPressed(recognizer: UILongPressGestureRecognizer) {
        
        // 押された位置でcellのPathを取得
        let point = recognizer.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        
        if indexPath == nil {
            
        } else if recognizer.state == UIGestureRecognizerState.Began  {
            let alertController = UIAlertController(title: "確認", message: "このグループから退出しますか？", preferredStyle: .Alert)
            let otherAction = UIAlertAction(title: "OK", style: .Default) {
                action in
                
                if(ApiConnection.post("outgroup", message: "{\"user_id\":\"" + self.myId + "\",\"group_id\":\"" + self.groupId[indexPath!.row] + "\"}") == "0"){
                    self.tableView.reloadData()
                    let alertController1 = UIAlertController(title: "グループ退出", message: "グループから退出しました。", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Default) {
                        action in
                    }
                    alertController1.addAction(okAction)
                    self.presentViewController(alertController1, animated: true, completion: nil)
                }
            }
            let cancelAction = UIAlertAction(title: "CANCEL", style: .Cancel) {
                action in
            }
            
            alertController.addAction(otherAction)
            alertController.addAction(cancelAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
}
