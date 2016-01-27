//
//  ViewController.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/12/02.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var postArray:[TimeLine] = []
    var refreshControl:UIRefreshControl!
    var postImage:UIImage?
    
    var defaultCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //上に引っ張るとリロードされる動作の設定
    func refreshContoll(){
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.defaultCollectionView!.addSubview(refreshControl)
    }
    
    //投稿画面へ遷移する
    func showPost(){
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
        //投稿文をダウンロードする
    }
    
    //セル数の指定
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.postArray.count
    }
    
    //セルの生成
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TimeLineCell", forIndexPath: indexPath) as! TimeLineCollectionViewCell
        cell.displayUpdate(self.postArray[indexPath.row])
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
    func getHightOfPhoto(indexPath: NSIndexPath, width: CGFloat) -> CGFloat {
        
        let post = postArray[indexPath.row]
        let URL = NSURL(string: post.imageURL!)
        let data = NSData(contentsOfURL: URL!)//取得するのに時間が掛かるので非同期通信にする
        self.postImage = UIImage(data: data!)

        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        
        /*
        //非同期通信した後に再度、UICollectionViewLayoutのprepareLayout()を実行しないといけないと反映されない
        ImageFetcher(imageURL: post.imageURL!).download{(items) -> Void in
            self.postImage = UIImage(data: items)
            let rect  = AVMakeRectWithAspectRatioInsideRect(self.postImage!.size, boundingRect)
            self.height =  rect.size.height
            self.defaultCollectionView?.reloadData()
        }
        */
        
        //calculate a height that retains the photo’s aspect ratio, restricted to the cell’s width
        let rect  = AVMakeRectWithAspectRatioInsideRect(self.postImage!.size, boundingRect)
        return rect.size.height
    }
    
    //投稿文の長さに応じて写真以外のセルの高さを調整する
    func getHightOfAnnotation(indexPath: NSIndexPath, width: CGFloat) -> CGFloat {
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



import Alamofire

class ImageFetcher {
    
    var url:String?
    
    init(imageURL: String){
        self.url = imageURL
    }
    
    func download(collback:(NSData) -> Void){
        Alamofire.request(.GET, url!).response { (request, response, data, error) in
            if let data = data {
                collback(data)
            }
        }
        
    }
    
}
