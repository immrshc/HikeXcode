//
//  PostController.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/12/02.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import UIKit

class PostController: UIViewController {

    @IBOutlet weak var postBackIV: UIImageView!
    @IBOutlet weak var postShowTV: UITextView!
    @IBOutlet weak var selectImageTB: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postBackIV.image = UIImage(named:"postBackImage.jpg")
        //キャンセルが押されると元の画面に戻るアクションメソッドを追加
        //doneが押されると投稿処理をするアクションメソッドを追加
    }
    //キャンセルが押されると元の画面に戻るアクションメソッド
    //doneが押されると投稿処理をするアクションメソッド
    //Postインスタンスを生成
    //PostインスタンスをDispatcherの引数にする
    @IBAction func cancelPost(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func doPost(sender: AnyObject) {
        if let text:String = self.postShowTV.text {
                print("dopost")
                let image = String(self.postBackIV.sd_imageURL())
                print("\(image)")
                let post = Post(content: text, imageURL: image)
                post.locationUpdate()
                PostDispatcher().download(post)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
}
