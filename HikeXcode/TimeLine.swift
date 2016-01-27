//
//  TimeLine.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/11/19.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import SwiftyJSON

class TimeLine {

    private (set) var favoriteCheck:Bool = false
    private (set) var favoriteCount:Int = 0
    private (set) var username:String?
    private (set) var text:String?
    private (set) var imageURL:String?
    private (set) var latitude:Double?
    private (set) var longitude:Double?

    init(
        favoriteCheck: Bool,
        favorite_count: Int,
        username: String,
        text: String,
        imageURL: String,
        latitude: Double,
        longitude: Double
    ){
        self.favoriteCheck = favoriteCheck
        self.favoriteCount = favorite_count
        self.username = username
        self.text = text
        //URLを取得してsd_setImageWithURLで取得する
        self.imageURL = imageURL
        self.latitude = latitude
        self.longitude = longitude
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
    
    //投稿文のラベルの高さを返す
    func heightForComment(font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: self.text!).boundingRectWithSize(CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        //数値式以上の最小の整数を戻す
        //print("ceil(rect.height): \(ceil(rect.height))")
        return ceil(rect.height)
    }
    
}

class TimeLineWrapper {
    
    static var imageURL = String(NSBundle.mainBundle().URLForResource("Image02", withExtension: "jpg")!)
    
    static func getInstance(json:JSON) -> TimeLine {
        
        //URLが指定されているかどうか確認する
        if json["imageURL"] != nil && json["imageURL"].stringValue.utf16.count != 0 {
            self.imageURL = json["imageURL"].stringValue
        }
        
        let timeLine = TimeLine (
            favoriteCheck: json["favorite"].boolValue,
            favorite_count: json["favorite_count"].intValue,
            username: json["user"]["username"].stringValue,
            text: json["text"].stringValue,
            imageURL: imageURL,
            latitude: json["latitude"].doubleValue,
            longitude: json["longitude"].doubleValue
        )
                
        return timeLine
    }
}
