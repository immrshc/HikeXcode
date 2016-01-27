//
//  User.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/11/19.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import SwiftyJSON

class User{
    
    //{"id":1,"username":"ShoichiImamura","result":true}を格納する

    private (set) var token: String
    private (set) var username: String
    //private(set) var userIcon: String?

    init(json:JSON){
        self.token = json["token"].stringValue
        self.username = json["username"].stringValue
        //self.userIcon = json["userIcon"].stringValue
    }
}
