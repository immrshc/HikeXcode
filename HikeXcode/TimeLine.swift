//
//  TimeLine.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/11/19.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import SwiftyJSON

class TimeLine {
    /*
    {"favorite":true,"favorite_count":3,"username":"ShoichiImamura","text":"これがはじめての投稿です","image":"MyString"}
    */
    var favoriteCheck:Bool = false
    var favoriteCount:Int = 0
    var username:String?
    var text:String?
    var imageURL:String = String(NSBundle.mainBundle().URLForResource("postBackImage02", withExtension: "jpg")!)
    //var imageURL:String = "http://parts.jbbs.shitaraba.net/material/wallpaper/bg_03_s.jpg"
    var latitude:Double?
    var longitude:Double?
    
    init(json:JSON){
        self.favoriteCheck = json["favorite"].boolValue
        self.favoriteCount = json["favorite_count"].intValue
        self.username = json["user"]["username"].stringValue
        self.text = json["text"].stringValue
        //URLを取得してsd_setImageWithURLで取得する
        //nilでなく文字列が指定されているならばURLとする
        if json["imageURL"] != nil && json["imageURL"].stringValue.utf16.count != 0 {
            self.imageURL = json["imageURL"].stringValue
        }
        self.latitude = json["latitude"].doubleValue
        self.longitude = json["longitude"].doubleValue
    }
    
    //お気に入り状態の切り替え
    func changeFavoriteState(){
        if self.favoriteCheck == true {
            self.favoriteCount -= 1
        } else {
            self.favoriteCount += 1
        }
        self.favoriteCheck = !self.favoriteCheck
    }
}
