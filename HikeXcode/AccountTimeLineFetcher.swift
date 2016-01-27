//
//  AccountTimeLineFetcher.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/12/02.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

class AccountTimeLineFetcher: TimeLineFetcher {
    
    init(selectedSegmentIndex: NSInteger){
        super.init()
        self.setURL(selectedSegmentIndex)
    }
    
    private func setURL(segmentIndex:NSInteger) -> Void {
        switch segmentIndex {
        case 0:
            //自分の投稿を表示する
            self.baseURL = URL.TimeLine.MyPost.getURL()
        case 1:
            //自分のお気に入りした投稿を表示する
            self.baseURL = URL.TimeLine.MyFavorite.getURL()
        default:
            print("error")
        }
    }
    
}

