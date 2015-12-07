//
//  TimeLineCollectionViewCell.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/11/19.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import UIKit

class TimeLineCollectionViewCell: UICollectionViewCell {

    var post:TimeLine?
    @IBOutlet weak var postIV: UIImageView!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var favoriteIconBtn: UIButton!
    
    func displayUpdate(timeline: TimeLine){
        self.post = timeline
        postTextLabel.text = self.post!.text
        postIV.sd_setImageWithURL(NSURL(string: post!.imageURL))
        
        favoriteIconBtn.addTarget(self, action: "favoriteUpdate:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(favoriteIconBtn)
        
        favoriteCountLabel.text = String(self.post!.favoriteCount)
        if self.post!.favoriteCheck {
            self.favoriteIconBtn.setTitleColor(UIColor.yellowColor(), forState: .Normal)
        } else {
            self.favoriteIconBtn.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        }
    }
    
    func favoriteUpdate(sender: UIButton){
        if let post:TimeLine = self.post {
            //お気に入りボタンが押されると色を変える
            if post.favoriteCheck == false {
                self.favoriteIconBtn.setTitleColor(UIColor.yellowColor(), forState: .Normal)
            } else {
                self.favoriteIconBtn.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
            }
            //お気に入り状態とお気に入り数を変更する
            post.changeFavoriteState()
            favoriteCountLabel.text = String(post.favoriteCount)
        }
    }
    
}
