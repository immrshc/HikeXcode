//
//  PostController.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/12/02.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import UIKit

class PostController: UIViewController {

    @IBOutlet weak var cancelTapBtn: UIBarButtonItem!
    @IBOutlet weak var postTapBtn: UIBarButtonItem!
    @IBOutlet weak var postBackIV: UIImageView!
    @IBOutlet weak var postShowTV: UITextView!
    @IBOutlet weak var selectImageTB: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postBackIV.sd_setImageWithURL(NSURL(string: "postBackImage.jpg"))
        //キャンセルが押されると元の画面に戻るアクションメソッドを追加
        //doneが押されると投稿処理をするアクションメソッドを追加
    }
    //キャンセルが押されると元の画面に戻るアクションメソッド
    //doneが押されると投稿処理をするアクションメソッド
    //Postインスタンスを生成
    //PostインスタンスをDispatcherの引数にする

}
