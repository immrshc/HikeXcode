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
    
    var baseURL = "http://localhost:3000/post/create.json"
    var params:[String:[String:AnyObject]] = [:]
    var post:Post?
    
    init(post:Post){
        self.post = post
    }
    
    func download(callback: (Bool) -> Void){
        if let id:Int = post?.id,
            let userName:String = post?.userName,
            let postContent:String = post?.postContent,
            let postImageURL:String = post?.postImageURL,
            let latitude:Double = post?.latitude,
            let longitude:Double = post?.longitude {
                self.params = [
                    "user":[
                        "id": id,
                        "username": userName],
                    "post":[
                        "text": postContent,
                        "image": postImageURL,
                        "latitude": latitude,
                        "longitude": longitude]
                ]
        
                Alamofire.request(.GET, baseURL, parameters: params).responseJSON{_, _, result in
                    if result.isSuccess,
                        let res = result.value as? [String:AnyObject]{
                            print("投稿確認：\(res["result"]!.intValue)")
                            if res["result"]!.intValue == 1 {
                                callback(true)
                            } else {
                                callback(false)
                            }
                    }
                }
        }
    }
}
