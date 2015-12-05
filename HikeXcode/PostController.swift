//
//  PostController.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/12/02.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import UIKit

class PostController: UIViewController {
    
    var latitude: Double?
    var longitude: Double?

    @IBOutlet weak var postBackIV: UIImageView!
    @IBOutlet weak var postShowTV: UITextView!
    @IBOutlet weak var selectImageTB: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //PostクラスでlocationManagerが実行できるかのテスト
        //Post(content: "", imageURL: "", latitude: 0, longitude: 0).locationUpdate()
        //Postでは出来なくて、PostControllerでは出来るのはなぜか質問する
        
        postBackIV.image = UIImage(named:"postBackImage.jpg")
        
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        if let latitude = app.sharedUserData["latitude"] as? Double,
            let longitude = app.sharedUserData["longitude"] as? Double {
                self.latitude = latitude
                self.longitude = longitude
                print("ユーザの投稿時の緯度経度：\(latitude), \(longitude)")
        }
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
