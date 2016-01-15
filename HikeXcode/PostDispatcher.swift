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

    //var postURL = "http://localhost:3000/post/create.json"
    var postURL = URL.Post.Text.getURL()
    //var uploadURL = "http://localhost:3000/post/upload_process.json"
    var uploadURL = URL.Post.Image.getURL()
    var params:[String:[String:AnyObject]] = [:]
    var post:Post?
    //指定したリソースファイル名と拡張子から、ファイルのある位置のフルパスをNSURLで返す
    var fileURL = NSBundle.mainBundle().URLForResource("Image02", withExtension: "jpg")!
    
    init(post:Post){
        self.post = post
    }
    
    //画像以外をリクエスト
    func download(callback: (Bool) -> Void){
        if let token:String = post?.token,
            let userName:String = post?.userName,
            let postContent:String = post?.postContent,
            let latitude:Double = post?.latitude,
            let longitude:Double = post?.longitude {
                self.params = [
                    "user":[
                        "token": token,
                        "username": userName],
                    "post":[
                        "text": postContent,
                        "latitude": latitude,
                        "longitude": longitude]
                ]
                
                Alamofire.request(.GET, postURL, parameters: params).responseJSON{_, _, result in
                    if result.isSuccess,
                        let res = result.value as? [String:AnyObject]{
                            print("投稿確認：\(res["result"]!.intValue)")
                            if res["result"]!.intValue == 1 {
                                callback(true)
                            } else {
                                callback(false)
                            }
                    } else {
                            callback(false)
                    }
                }
        }
    }

    //画像のアップロードと投稿情報のリクエストをする
    func upload(callback: (Bool) -> Void){
        
        
        if let postImage:NSString = NSString(string: post!.imageURL!) {
                self.fileURL = NSBundle.mainBundle().URLForResource(postImage.stringByDeletingPathExtension, withExtension: postImage.pathExtension)!
        }
        
        Alamofire.upload(.POST, uploadURL, multipartFormData: { (multipartFormData) in
            //画像をアップロードする
            multipartFormData.appendBodyPart(fileURL: self.fileURL, name: "image")
            },
            //リクエストボディ生成のエンコード処理が完了したら呼ばれる
            encodingCompletion: { (encodingResult) in
                switch encodingResult {
                    //エンコード成功時
                    case .Success(let upload, _, _):
                        upload.responseJSON { _, _, result in
                            print("result:\(result.isSuccess)")
                            callback(result.isSuccess)
                    }
                    //エンコード失敗時
                    case .Failure(let encodingError):
                        print(encodingError)
                        callback(false)
                    }
            })
    }
}
