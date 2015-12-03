//
//  PostDispatcher.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/12/03.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import Alamofire
import SwiftyJSON

class PostDispatcher {
    
    var baseURL = "http://localhost:3000/timeline/show_timeline.json"
    var params:[String:AnyObject] = [:]
    
    func download(post:Post){
        if let id:Int = post.id,
            let userName:String = post.userName,
            let postContent:String = post.postContent,
            let postImageURL:String = post.postImageURL,
            let latitude:Double = post.latitude,
            let longitude:Double = post.longitude {
                self.params = [
                                "id": id,
                                "userName": userName,
                                "postContent": postContent,
                                "postImageURL": postImageURL,
                                "latitude": latitude,
                                "longitude": longitude
                            ]
        }
        
        Alamofire.request(.GET, baseURL, parameters: params).responseJSON{_, _, result in
            if result.isSuccess,
                let posts = result.value as? [AnyObject]{
                    print("posts[0]:\(posts[0])")
                    var postArray:[TimeLine] = []
                    for var i = 0; i < posts.count; i++ {
                        let post = TimeLine(json: JSON(posts[i]))
                        postArray.append(post)
                    }
                    print("\(self.params["postContent"]!)")
                    //callback(postArray)
            }
        }
    }
    
}
