//
//  WaitViewController.swift
//  atsumare
//
//  Created by KawakawaPlanning on 2016/01/09.
//  Copyright © 2016年 KawakawaPlanning. All rights reserved.
//

import UIKit
import SwiftyJSON

class WaitViewController: UIViewController {
    
    var mGroupId = ""
    var mMyId = ""
    var cells: [LoginModel] = [LoginModel]()
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
    @IBOutlet weak var tableView: UITableView!
    var timer:NSTimer! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "グループ待ち"
        let leftBarButton = UIBarButtonItem(title: "キャンセル", style: .Plain, target: self, action: "back")
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        mMyId = appDelegate.myId
        mGroupId = appDelegate.groupId
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // タイマー生成、開始 1秒後の実行
        timer = NSTimer.scheduledTimerWithTimeInterval(
            1.0,                              // 時間間隔
            target:self,                       // タイマーの実際の処理の場所
            selector: Selector("tickTimer:"),   // メソッド タイマーの実際の処理
            userInfo: nil,
            repeats: true)                      // 繰り返し
        
        timer.fire()
        
        ApiConnection.post("grouplogin", message: "{\"user_id\":\"" + mMyId + "\",\"group_id\":\"" + mGroupId + "\"}")
        
        
    }
    
    func back() {
        //戻る処理的な何か
        timer.invalidate()
        self.dismissViewControllerAnimated(true, completion: nil)
        ApiConnection.post("grouplogout", message: "{\"user_id\":\"" + mMyId + "\",\"group_id\":\"" + mGroupId + "\"}")
    }
    
    // タイマー処理
    func tickTimer(timer: NSTimer) {//ここのtimerには生成元のtimerが入ってるっぽい
        cells.removeAll(keepCapacity: false)
        var json = JSON.parse(ApiConnection.post("loginstate" , message: "{\"group_id\":\"" + mGroupId + "\"}"))
        for var i = 0; i < json["data"].count; i++ {
            var loginnow = false
            if(mGroupId == json["data"][i]["login_now"].stringValue){
                loginnow = true
            }
            let data = LoginModel(id: json["data"][i]["user_id"].stringValue, name: json["data"][i]["user_name"].stringValue,loginnow:loginnow)
            cells.append(data)
        }
        self.tableView.reloadData()
        
        var loginCheck:Bool = true
        for var i = 0; i < cells.count ; i++ {
            if(!cells[i].loginnow){
                loginCheck = false
            }
        }
        
        if(loginCheck || json["using"].int == 0){
            //全員がログインしている || すでに始めている
            timer.invalidate()
            self.performSegueWithIdentifier("toMap",sender: nil)
        }
        
    }
    
}

extension WaitViewController: UITableViewDelegate, UITableViewDataSource {
    // セルの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    // セルの内容を変更
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        //        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle ,reuseIdentifier: "CustomCell")
        //        cell.textLabel!.text = groupName[indexPath.row]
        //        cell.detailTextLabel!.text = "GroupID:" + groupId[indexPath.row]
        //        cell.backgroundColor = UIColor(red:1.0,green:0.98,blue:	0.875,alpha:1.0)
        let cell: CustomCell = tableView.dequeueReusableCellWithIdentifier("CustomCell", forIndexPath: indexPath) as! CustomCell
        
        cell.setCell(cells[indexPath.row])
        
        return cell;
    }
    
    
    // セル選択リスナ
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
