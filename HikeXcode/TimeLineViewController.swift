//
//  TimeLineController.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/11/19.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import UIKit
import MapKit

class TimeLineViewController: ViewController {
    
    @IBOutlet var collectionView: UICollectionView!
        
    override func viewDidLoad() {
       super.viewDidLoad()
        
    }
    
    override func getTimeLine(){
        TimeLineFetcher().download { (items) -> Void in
            self.postArray = items
            self.collectionView?.reloadData()
        }
    }
    
    override func setCollectionView() -> UICollectionView! {
        return collectionView
    }
    
    override func setDelegateOfLayout(){
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }
    
    //上に引っ張ると投稿をリロードする
    override func refresh(){
        TimeLineFetcher().download { (items) -> Void in
            self.postArray = items
            self.refreshControl.endRefreshing()
            self.collectionView?.reloadData()
        }
    }
    
    //投稿画面へ遷移する
    @IBAction func postDo(sender: AnyObject) {
        self.showPost()
    }
    
    //アスペクト比に応じた写真の高さを取得して、セルの写真の高さにする
    override func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath,
        withWidth width: CGFloat) -> CGFloat {
            let post = postArray[indexPath.row]
            let imageSize = post.imageInfo?.size
            print("imageSize: \(imageSize)")
            let height = LayoutCalculator.calculateHeightOfPhotoWithAspectRatio(width, imageSize: imageSize!)
            return height
    }
    
    //投稿文の長さに応じて写真以外のセルの高さを調整する
    override func collectionView(collectionView: UICollectionView,
        heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
            //フォントとセルの幅からラベルの高さを返す
            let font = UIFont(name: "Times New Roman", size: 20)!
            let post:TimeLine = postArray[indexPath.row]
            let commentHeight = post.heightForComment(font, width: width)
            let height = LayoutCalculator.calculateHeightOfAnnotation(commentHeight)
            return height
    }
}


