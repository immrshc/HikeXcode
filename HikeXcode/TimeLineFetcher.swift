//
//  TimeLineFetcher.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/11/19.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import Alamofire
import SwiftyJSON

class TimeLineFetcher {
    
    var baseURL = "http://localhost:3000/timeline/show_timeline.json"
    var defaultParameter:[String:[String:AnyObject]] = [:]
    let app = UIApplication.sharedApplication().delegate as! AppDelegate
    //String(app.sharedUserData["id"])とするとクラスが初期化される前にappを参照するのでエラーが起こるのでインスタンス生成時に設定させる
    //http://stackoverflow.com/questions/32693150/whats-wrong-here-instance-member-cannot-be-used-on-type
    init(){
        //引数でSwitch文でbaseURLを変更する
        self.defaultParameter = ["user":["id":(app.sharedUserData["id"]?.integerValue)!]]
    }
    
    func download(callback:([TimeLine])->Void){
        Alamofire.request(.GET, baseURL, parameters: defaultParameter).responseJSON{_, _, result in
            if result.isSuccess,
                let posts = result.value as? [AnyObject]{
                    var postArray:[TimeLine] = []
                    for var i = 0; i < posts.count; i++ {
                        let post = TimeLine(json: JSON(posts[i]))
                        postArray.append(post)
                    }
                    callback(postArray)
            }
        }
    }
    
    
}
