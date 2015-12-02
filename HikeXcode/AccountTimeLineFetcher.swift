//
//  AccountTimeLineFetcher.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/12/02.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

class AccountTimeLineFetcher: TimeLineFetcher {
    init(selectedSegmentIndex: Int){
        super.init()
        switch selectedSegmentIndex {
        case 0:
            //自分の投稿を表示する
            self.baseURL = "http://localhost:3000/timeline/show_mypost.json"
        case 1:
            //自分のお気に入りした投稿を表示する
            self.baseURL = "http://localhost:3000/timeline/show_myfavorite.json"
        default:
            print("error")
        }
    }
}
