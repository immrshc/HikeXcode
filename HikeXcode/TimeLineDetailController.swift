//
//  TimeLineDetailController.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/11/19.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import UIKit
import MapKit

class TimeLineDetailController: UIViewController {
    
    var post:TimeLine!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postIV: UIImageView!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var favoriteIconBtn: UIButton!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var detailMV: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
            self.userNameLabel.text = post.username
            self.postLabel.text = post.text
            self.postIV.sd_setImageWithURL(NSURL(string: post.imageURL!))
            self.favoriteCountLabel.text = String(post.favoriteCount)
        
            favoriteIconBtn.addTarget(self, action: "favoriteUpdate:", forControlEvents: UIControlEvents.TouchUpInside)

            //これはセルのクラスではないので、addSubViewがなくても認識される
            //view.addSubview(favoriteIconBtn)
            //上のようにviewに追加するとボタンが再生成されて位置が変わる
        
            if self.post.favoriteCheck {
                self.favoriteIconBtn.setTitleColor(UIColor.yellowColor(), forState: .Normal)
            } else {
                self.favoriteIconBtn.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
            }
        
        //地図にピンを立てる
        if let latitude = post.latitude,
            let longtitude = post.longitude {
                print("投稿ごとの緯度経度:\(latitude),\(longtitude)")
                let co = CLLocationCoordinate2DMake(latitude, longtitude)
                let rg = MKCoordinateRegionMakeWithDistance(co, 3000, 3000)
                detailMV.setRegion(rg, animated: false)
                
                //投稿のピン
                let postPin = MKPointAnnotation()
                postPin.coordinate = co
                postPin.title = post.username
                detailMV.addAnnotation(postPin)
                
                //ユーザのピン
                let app = UIApplication.sharedApplication().delegate as! AppDelegate
                if let userLatitude = app.sharedUserData["latitude"] as? Double,
                    let userLongtitude = app.sharedUserData["longitude"] as? Double {
                        let userPin = MKPointAnnotation()
                        userPin.coordinate = CLLocationCoordinate2DMake(userLatitude, userLongtitude)
                        userPin.title = "現在地"
                        detailMV.addAnnotation(userPin)
                }
        }
        
    }
    
    func favoriteUpdate(sender: UIButton){
        //お気に入りボタンが押されると色を変える
        if self.post.favoriteCheck == false {
            self.favoriteIconBtn.setTitleColor(UIColor.yellowColor(), forState: .Normal)
        } else {
            self.favoriteIconBtn.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        }
        //お気に入り状態とお気に入り数を変更する
        post.changeFavoriteState()
        favoriteCountLabel.text = String(post.favoriteCount)
    }
}
