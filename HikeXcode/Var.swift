//
//  var.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2016/01/15.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

enum URL {
    
    enum Base: String {
        case Protocol = "http://"
        //サーバのIPが変わった場合はここだけを変更すれば良い
        case Host = "localhost:3000"
    }
    
    enum Login: String {
        //ログイン時のユーザ認証
        case Auth = "/login/auth.json"
        func getURL() -> String {
            return URL.Base.Protocol.rawValue + URL.Base.Host.rawValue + self.rawValue
        }
    }
    
    enum TimeLine: String {
        //全てのタイムラインの表示
        case TimeLine = "/timeline/show_timeline.json"
        //自分の投稿の表示
        case MyPost = "/timeline/show_mypost.json"
        //お気に入りの投稿の表示
        case MyFavorite = "/timeline/show_myfavorite.json"
        func getURL() -> String  {
            return URL.Base.Protocol.rawValue + URL.Base.Host.rawValue + self.rawValue
        }
    }
    
    enum Post: String {
        //投稿文のリクエスト
        case Text = "/post/create.json"
        //画像のアップロード
        case Image = "/post/upload_process.json"
        func getURL() -> String {
            return URL.Base.Protocol.rawValue + URL.Base.Host.rawValue + self.rawValue
        }
    }
    
}
