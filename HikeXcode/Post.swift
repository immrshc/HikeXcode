//
//  Post.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/12/03.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import UIKit
import CoreLocation

class Post {
    
    private let app = UIApplication.sharedApplication().delegate as! AppDelegate
    private (set) var token:String?
    private (set) var userName:String?
    private (set) var postContent:String?
    private (set) var imageURL:String?
    private (set) var latitude:Double?
    private (set) var longitude:Double?
    
    init(content:String, imageURL:String, latitude:Double, longitude:Double){

        self.token = app.sharedUserData["token"] as? String
        self.userName = app.sharedUserData["username"] as? String
        
        self.postContent = content
        self.imageURL = imageURL
        
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
}


class PostWrapper {

    static func getInstance(args:[String:AnyObject]) -> Post {

        if let content = args["Content"] as? String,
            let imageURL = args["ImageURL"] as? String,
            let latitude = args["Latitude"] as? Double,
            let longitude = args["Longitude"] as? Double {
                let post = Post(content: content, imageURL: imageURL, latitude: latitude, longitude: longitude)
                return post
        } else {
            print("Postの初期化に失敗しました")
            return Post(content: "", imageURL: "", latitude: 0.0, longitude: 0.0)
        }
    }
    
}

