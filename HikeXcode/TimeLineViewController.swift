//
//  TimeLineController.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/11/19.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation

class TimeLineViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, PinterestLayoutDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var postArray:[TimeLine] = []
    var refreshControl:UIRefreshControl!
    var postImage:UIImage?
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        TimeLineFetcher().download { (items) -> Void in
            self.postArray = items
            self.collectionView?.reloadData()
        }
        
        //上に引っ張るとリロードされる動作の設定
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView!.addSubview(refreshControl)
        
        //Pinterestのプロトコルを後で実装する
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
    }
    
    //投稿画面へ遷移する
    @IBAction func postDo(sender: AnyObject) {
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PostNC")
            as? UINavigationController {
                self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    //背景が黒の場合、ステータスバーを白色にする
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //上に引っ張ると投稿をリロードする
    func refresh(){
        TimeLineFetcher().download { (items) -> Void in
            self.postArray = items
            self.refreshControl.endRefreshing()
            self.collectionView?.reloadData()
        }
    }
    
    //セル数の指定
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.postArray.count
    }
    
    //セルの生成
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TimeLineCell", forIndexPath: indexPath) as! TimeLineCollectionViewCell
        cell.displayUpdate(self.postArray[indexPath.row])
        //print("text of cell: \(cell.postTextLabel.text)")
        return cell
    }
    
    //セクション数の指定
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //詳細画面への遷移
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("TimeLineDetailVC") as? TimeLineDetailController {
            vc.post = self.postArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //アスペクト比に応じた写真の高さを取得して、セルの写真の高さにする
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath,
        withWidth width: CGFloat) -> CGFloat {
            let post = postArray[indexPath.row]
            let URL = NSURL(string: post.imageURL)
            let data = NSData(contentsOfURL: URL!)
            self.postImage = UIImage(data: data!)
            let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
            //calculate a height that retains the photo’s aspect ratio, restricted to the cell’s width
            let rect  = AVMakeRectWithAspectRatioInsideRect(postImage!.size, boundingRect)
            //print("\(indexPath.row): rect.size.height:\(rect.size.height)")
            return rect.size.height
    }
    
    //投稿文の長さに応じて写真以外のセルの高さを調整する
    func collectionView(collectionView: UICollectionView,
        heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
            let annotationPadding = CGFloat(14) + CGFloat(5)
            let favoriteHeaderHeight = CGFloat(20)
            let post:TimeLine = postArray[indexPath.row]
            let font = UIFont(name: "Times New Roman", size: 20)!
            //フォントとセルの幅からラベルの高さを返す
            let commentHeight = post.heightForComment(font, width: width)
            let height = annotationPadding + favoriteHeaderHeight + commentHeight
            //print("commentHeight at TimeLine: \(commentHeight)")
            //print("height at TimeLine: \(height)")
            return height
    }
    
}


