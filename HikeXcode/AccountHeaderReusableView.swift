//
//  AccountCollectionViewCell.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/11/28.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import UIKit

class AccountHeaderReusableView: UICollectionReusableView {

    //CollectionVIewのヘッダー
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIconIV: UIImageView!
    @IBOutlet weak var changePostTapBtn: UISegmentedControl!
    
    func displayUpdate(){
        
        //ヘッダーにユーザ情報を表示させる
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        if let userName:String = app.sharedUserData["username"] as? String//,
            //let userIcon:String = app.sharedUserData["usericon"] as? String 
        {
            self.userNameLabel.text = userName
            self.userIconIV.sd_setImageWithURL(NSURL(string: "http://parts.jbbs.shitaraba.net/material/wallpaper/bg_04_s.gif"))
            //self.userIconIV.sd_setImageWithURL(NSURL(string: userIcon))

        }
    }
}
