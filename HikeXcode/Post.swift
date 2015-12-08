//
//  Post.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/12/03.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import UIKit
import CoreLocation

class Post/*: NSObject, CLLocationManagerDelegate*/ {
    
    let app = UIApplication.sharedApplication().delegate as! AppDelegate
    //var lm:CLLocationManager!
    var token:String?
    var userName:String?
    var postContent:String?
    var imageURL:String?
    var latitude:Double?
    var longitude:Double?
    
    init(content:String, imageURL:String, latitude:Double, longitude:Double){
    //init(content:String, latitude:Double, longitude:Double){
        

        self.token = app.sharedUserData["token"] as? String
        self.userName = app.sharedUserData["username"] as? String
        
        self.postContent = content
        self.imageURL = imageURL
        
        self.latitude = latitude
        self.longitude = longitude
    }

    //PostControllerでPost().locationUpdateをしてもlocationManagerが実行されないが、
    //PostControllerのviewDidLoader()なら実行される
    //質問する
    /*
    func locationUpdate(){
        lm = CLLocationManager()
        longitude = CLLocationDegrees()
        latitude = CLLocationDegrees()
        
        lm.delegate = self
        //位置情報取得の許可
        lm.requestAlwaysAuthorization()
        //位置情報の精度
        lm.desiredAccuracy = kCLLocationAccuracyBest
        //指定した値分移動したら位置情報を更新する
        lm.distanceFilter = 1000
        //GPSの使用を開始する
        lm.startUpdatingLocation()
        print("startUpdatingLocationを実行")
    }
    
    //位置情報取得成功時に実行
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        latitude = Double(newLocation.coordinate.latitude)
        longitude = Double(newLocation.coordinate.longitude)
        print("latitude: \(latitude) , longitude: \(longitude)")
    }
    
    //位置情報取得失敗時に実行
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("ErrorDomain: \(error.domain)")
        print("ErrorCode: \(error.code)")
    }
    */
}
