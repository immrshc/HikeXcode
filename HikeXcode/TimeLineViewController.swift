//
//  TimeLineController.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/11/19.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import UIKit
import MapKit

class TimeLineViewController: ViewController, PinterestLayoutDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
        
    override func viewDidLoad() {
       super.viewDidLoad()
        
        self.defaultCollectionView = collectionView
        
        //上に引っ張るとリロードされる動作の設定
        self.refreshContoll()
        
        //Pinterestのプロトコルを後で実装する
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }

        TimeLineFetcher().download { (items) -> Void in
            self.postArray = items
            self.collectionView?.reloadData()
        }

    }
    
    //投稿画面へ遷移する
    @IBAction func postDo(sender: AnyObject) {
        self.showPost()
    }
    
    //上に引っ張ると投稿をリロードする
    override func refresh(){
        TimeLineFetcher().download { (items) -> Void in
            self.postArray = items
            self.refreshControl.endRefreshing()
            self.collectionView?.reloadData()
        }
    }
    
    //アスペクト比に応じた写真の高さを取得して、セルの写真の高さにする
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath,
        withWidth width: CGFloat) -> CGFloat {
            let height =  self.getHightOfPhoto(indexPath, width: width)
            return height
    }
    
    //投稿文の長さに応じて写真以外のセルの高さを調整する
    func collectionView(collectionView: UICollectionView,
        heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
            let height = self.getHightOfAnnotation(indexPath, width: width)
            return height
    }
    
}


