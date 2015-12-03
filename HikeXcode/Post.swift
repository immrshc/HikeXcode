//
//  Post.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/12/03.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import UIKit
import CoreLocation

class Post: NSObject, CLLocationManagerDelegate {
    
    var lm:CLLocationManager!
    var id:Int?
    var userName:String = ""
    var postContent:String?
    var postImageURL:String?
    var latitude:Double?
    var longitude:Double?
    
    init(content:String, imageURL:String, latitude:Double, longitude:Double){
        
        self.id = 1
        self.userName = "aasa"
        
        self.postContent = "投稿文章の内容"
        self.postImageURL = imageURL
        
        self.latitude = latitude
        self.longitude = longitude
    }
}
