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
    
    let lm = CLLocationManager()
    var id:Int?
    var userName:String = ""
    var postContent:String?
    var postImageURL:String?
    var latitude:CLLocationDegrees!
    var longitude:CLLocationDegrees!
    
    init(content:String, imageURL:String){
        
        self.id = 1
        self.userName = "aasa"
        
        self.postContent = "a"
        self.postImageURL = imageURL
    }
    
    func locationUpdate(){
        lm.delegate = self
        lm.requestAlwaysAuthorization()
        lm.desiredAccuracy = kCLLocationAccuracyBest
        lm.distanceFilter = 100
        lm.startUpdatingLocation()
        print("startUpdatingLocation")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        print("位置情報を取得")
        self.latitude = newLocation.coordinate.latitude
        self.longitude = newLocation.coordinate.longitude
        print("latitude: \(latitude), longtitude: \(longitude)")
        lm.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("ErrorDomain: \(error.domain)")
        print("ErrorCode: \(error.code)")
        //http://stackoverflow.com/questions/1409141/location-manager-error-kclerrordomain-error-0
    }
}
