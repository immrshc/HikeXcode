//
//  Post.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/12/03.
//  Copyright © 2015年 今村翔一. All rights reserved.
//


class Post {
    
    var id:Int?
    var userName:String = ""
    var postContent:String?
    var postImageURL:String?
    var latitude:Double?
    var longitude:Double?
    /*
    init(content:String, imageURL:String){
        
        self.id =
        self.userName =
        
        self.postContent =
        self.postImageURL =
        
        self.latitude =
        self.longitude =
    }
    */

    /*
    var favoriteCheck:Bool = false
    var favoriteCount:Int = 0
    var username:String?
    var text:String?
    var imageURL:String? = "http://parts.jbbs.shitaraba.net/material/wallpaper/bg_03_s.jpg"
    //var latitude:Double?
    //var longitude:Double?
    
    init(json:JSON){
        self.favoriteCheck = json["favorite"].boolValue
        self.favoriteCount = json["favorite_count"].intValue
        self.username = json["username"].stringValue
        self.text = json["text"].stringValue
        //self.imageURL = json["image"].stringValue
        //self.latitude = json["latitude"].doubleValue
        //self.longitude = json["longitude"].doubleValue
    }
    */
}
