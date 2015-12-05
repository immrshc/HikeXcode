//
//  PostController.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/12/02.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import UIKit
import CoreLocation

class PostController: UIViewController, CLLocationManagerDelegate {
    
    var lm: CLLocationManager!
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!

    @IBOutlet weak var postBackIV: UIImageView!
    @IBOutlet weak var postShowTV: UITextView!
    @IBOutlet weak var selectImageTB: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //PostクラスでlocationManagerが実行できるかのテスト
        //Post(content: "", imageURL: "", latitude: 0, longitude: 0).locationUpdate()
        //Postでは出来なくて、PostControllerでは出来るのはなぜか質問する
        
        postBackIV.image = UIImage(named:"postBackImage.jpg")
        
        lm = CLLocationManager()
        longitude = CLLocationDegrees()
        latitude = CLLocationDegrees()

        lm.delegate = self
        // 位置情報取得の許可
        lm.requestAlwaysAuthorization()
        // 位置情報の精度
        lm.desiredAccuracy = kCLLocationAccuracyBest
        // 指定した値分移動したら位置情報を更新する
        lm.distanceFilter = 1000
        // GPSの使用を開始する
        lm.startUpdatingLocation()
        
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
        //http://stackoverflow.com/questions/1409141/location-manager-error-kclerrordomain-error-0
    }

    @IBAction func cancelPost(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func doPost(sender: AnyObject) {
        if let text:String = self.postShowTV.text,
            //let image:String = self.postBackIV.sd_imageURL() as? String,
            let latitude:Double = self.latitude,
            let longitude:Double = self.longitude {
                //let image = String(self.postBackIV.sd_imageURL())
                let image = "http://parts.jbbs.shitaraba.net/material/wallpaper/bg_03_s.jpg"
                let post = Post(content: text, imageURL: image, latitude: latitude, longitude: longitude)
                PostDispatcher(post: post).download{(result) -> Void in
                    if result {
                        print("投稿が完了しました")
                    } else {
                        print("投稿が失敗しました")
                    }
                }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
}
