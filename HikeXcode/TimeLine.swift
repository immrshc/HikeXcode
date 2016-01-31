//
//  TimeLine.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/11/19.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import SwiftyJSON

class TimeLine {

    struct ImageOfTimeLine {
        private (set) var url:String?
        private (set) var size: CGSize?
    }
    
    private (set) var favoriteCheck:Bool = false
    private (set) var favoriteCount:Int = 0
    private (set) var username:String?
    private (set) var text:String?
    private (set) var imageInfo:ImageOfTimeLine?
    private (set) var latitude:Double?
    private (set) var longitude:Double?
    
    init(
        favoriteCheck: Bool,
        favorite_count: Int,
        username: String,
        text: String,
        imageURL: String,
        imageSize: CGSize,
        latitude: Double,
        longitude: Double
    ){
        self.favoriteCheck = favoriteCheck
        self.favoriteCount = favorite_count
        self.username = username
        self.text = text
        self.imageInfo = ImageOfTimeLine(url: imageURL, size: imageSize)
        self.imageInfo?.size = imageSize
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
        return ceil(rect.height)
    }
    
}

class TimeLineWrapper {
    
    var imageURL = String(NSBundle.mainBundle().URLForResource("Image02", withExtension: "jpg")!)
    var imageSize:CGSize = (UIImage(named: "Image02.jpg")!.size)
    
    func getInstance(json:JSON) -> TimeLine {
        
        //画像のURLを指定する
        self.setImageURL(json)
        //画像のサイズを取得する
        self.setImageSize(json)
        
        let timeLine = TimeLine (
            favoriteCheck: json["favorite"].boolValue,
            favorite_count: json["favorite_count"].intValue,
            username: json["user"]["username"].stringValue,
            text: json["text"].stringValue,
            imageURL: imageURL,
            imageSize: imageSize,
            latitude: json["latitude"].doubleValue,
            longitude: json["longitude"].doubleValue
        )
        
        return timeLine
    }
    
    
    private func setImageURL(json: JSON){
        if json["imageURL"] != nil && json["imageURL"].stringValue.utf16.count != 0 {
            self.imageURL = json["imageURL"].stringValue
        }
    }
    
    
    private func setImageSize(json: JSON){
        if json["imageSize"]["width"] != nil && json["imageSize"]["height"] != nil {
            let width = json["imageSize"]["width"].doubleValue
            let height = json["imageSize"]["height"].doubleValue
            self.imageSize = CGSize(width: width, height: height)
        }
    }
    
}
