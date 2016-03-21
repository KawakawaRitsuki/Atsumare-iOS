//
//  LoginModel.swift
//  atsumare
//
//  Created by 五嶋 律樹 on 2016/01/22.
//  Copyright © 2016年 KawakawaPlanning. All rights reserved.
//

import Foundation
import UIKit

class LoginModel : NSObject{
    var id:NSString
    var name:NSString
    var image:UIImage?
    var loginnow:Bool
    
    init(id: String, name: String,loginnow: Bool){
        self.id = id
        self.name = name
        self.loginnow = loginnow
        if(loginnow){
            self.image = UIImage(named:"icon_success.png")
        }else{
            self.image = UIImage(named:"icon_error.png")
        }
    }
}