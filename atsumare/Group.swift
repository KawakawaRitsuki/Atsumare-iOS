//
//  Group.swift
//  atsumare
//
//  Created by 五嶋 律樹 on 2016/03/22.
//  Copyright © 2016年 KawakawaPlanning. All rights reserved.
//

import Foundation
import SwiftyJSON

class Group:NSObject{
    
    var myId = ""
    var groupId = ""
    var groupNames: [String] = []
    var groupIds: [String] = []
    var timer:NSTimer!
    
    init(myId: String,groupId:String) {
        self.myId = myId
        self.groupId = groupId
    }
    
    func getGroup() -> (name:[String],id:[String]){
        groupIds.removeAll(keepCapacity: false)
        groupNames.removeAll(keepCapacity: false)
        
        var json = JSON.parse(ApiConnection.post("getgroup", message: "{\"user_id\":\"" + myId + "\"}"))
        for var i = 0; i < json["data"].count; i++ {
            self.groupNames.append("\(json["data"][i]["group_name"])")
            self.groupIds.append("\(json["data"][i]["group_id"])")
        }
//        timer = NSTimer.scheduledTimerWithTimeInterval(
//            1.0,
//            target:self,
//            selector: Selector("tickTimer:"),
//            userInfo: nil,
//            repeats: true)
//        
//        timer.fire()
        return (groupNames,groupIds)
    }
    
}