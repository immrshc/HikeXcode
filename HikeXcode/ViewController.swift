//
//  ViewController.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/12/02.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, PinterestLayoutDelegate {
    
    var postArray:[TimeLine] = []
    var refreshControl:UIRefreshControl!
    var postImage:UIImage?
    var defaultCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UICollectionViewの設定
        self.defaultCollectionView = setCollectionView()
        
        //上に引っ張るとリロードされる動作の設定
        self.refreshContoll()
        
        //Pinterestのプロトコルを後で実装する
        self.setDelegateOfLayout()
        
        //タイムラインを非同期で取得する
        self.getTimeLine()
        
    }
    
    func getTimeLine(){
        print("タイムラインを非同期で取得する")
    }

    func setCollectionView() -> UICollectionView! {
        print("defaultCollectionViewに代入する")
        return nil
    }
   
    func setDelegateOfLayout(){
        print("レイアウトのデリゲートを設定する")
    }
    
    //上に引っ張ると投稿をリロードする
    func refresh(){
        //投稿文をダウンロードする
        print("OverrideForgotten")
    }
    
    //アスペクト比に応じた写真の高さを取得して、セルの写真の高さにする
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath,
        withWidth width: CGFloat) -> CGFloat {
            print("アスペクト比に応じた写真の高さを取得して返す")
            return 0.0
    }
    
    //投稿文の長さに応じて写真以外のセルの高さを調整する
    func collectionView(collectionView: UICollectionView,
        heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
            print("投稿文の長さに応じて写真以外のセルの高さを調整して返す")
            return 0.0
    }
    
    //上に引っ張るとリロードされる動作の設定
    private func refreshContoll(){
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
        
}


