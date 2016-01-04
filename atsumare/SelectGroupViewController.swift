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

class SelectGroupViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var groupName: [String] = []
    var groupId: [String] = []
    var myId: String = ""
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do view setup here.
        
        myId = defaults.stringForKey("myId")!
        print(myId)
        load()
    }
    
    func load(){
        groupId.removeAll(keepCapacity: false)
        groupName.removeAll(keepCapacity: false)
        let query = "{\"user_id\":\"" + myId + "\"}"
        let url:NSURL = NSURL(string:"http://kawakawaplanning.dip.jp:8080/getgroup")!
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        request.HTTPBody = query.dataUsingEncoding(NSUTF8StringEncoding)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response:NSURLResponse?, data:NSData?, error:NSError? ) in
                var json = JSON.parse( NSString(data: data!, encoding: NSUTF8StringEncoding)! as String )
                for var i = 0; i < json["data"].count; i++ {
                    self.groupName.append("\(json["data"][0]["group_name"])")
                    self.groupId.append("\(json["data"][0]["group_id"])")
                }
                self.tableView.reloadData()
        })
    }
    
    @IBAction func logout(){
        let alertController = UIAlertController(title: "確認", message: "本当にログアウトしてもいいですか？", preferredStyle: .Alert)
        let otherAction = UIAlertAction(title: "OK", style: .Default) {
            action in self.defaults.setObject("", forKey: "myId")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .Cancel) {
            action in print("Pushed CANCEL!")
        }
        
        alertController.addAction(otherAction)
        alertController.addAction(cancelAction)
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
    }
    
    
    
}
