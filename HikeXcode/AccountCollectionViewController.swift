//
//  AccountCollectionViewController.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/11/28.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import UIKit
import AVFoundation

class AccountCollectionViewController: UICollectionViewController, PinterestLayoutDelegate {
    
    var postArray:[TimeLine] = []
    var refreshControl:UIRefreshControl!
    var selectedIndex:NSInteger!
    var postImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ユーザIDに紐付いた自分の投稿を配列にする
        AccountTimeLineFetcher(selectedSegmentIndex: 0).download { (items) -> Void in
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
        
        //余白の長方形を設定する
        collectionView!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        

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
        AccountTimeLineFetcher(selectedSegmentIndex: selectedIndex).download { (items) -> Void in
            self.postArray = items
            self.refreshControl.endRefreshing()
            self.collectionView?.reloadData()
        }
    }
    
    //ヘッダーの生成
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind != UICollectionElementKindSectionHeader {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
        }
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "AccountHeader", forIndexPath: indexPath) as! AccountCollectionViewCell
        header.displayUpdate()
        let changePostTapBtn:UISegmentedControl = header.changePostTapBtn
        self.selectedIndex = changePostTapBtn.selectedSegmentIndex
        changePostTapBtn.addTarget(self, action: "postUpdate:", forControlEvents: UIControlEvents.ValueChanged)
        header.addSubview(changePostTapBtn)
        return header
    }
    
    /*
    //ヘッダーのサイズの設定
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            let size = CGSize(width: self.view.bounds.width, height: 100)
            return size
    }
    */


    //選択されたタブのインデックスで表示を変更する
    func postUpdate(segcon: UISegmentedControl){
        self.selectedIndex = segcon.selectedSegmentIndex
        AccountTimeLineFetcher(selectedSegmentIndex: selectedIndex).download { (items) -> Void in
            self.postArray = items
            self.collectionView?.reloadData()
        }
    }
    
    //セル数の指定
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.postArray.count
    }
    
    //セルの生成
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AccountCell", forIndexPath: indexPath) as! TimeLineCollectionViewCell
        cell.displayUpdate(self.postArray[indexPath.row])
        return cell
    }
    
    //詳細画面への遷移
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
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
            let annotationPadding = CGFloat(4)
            let favoriteHeaderHeight = CGFloat(17)
            let post = postArray[indexPath.row]
            let font = UIFont(name: "Times New Roman", size: 10)!
            //フォントとセルの幅からラベルの高さを返す
            let commentHeight = post.heightForComment(font, width: width)
            let height = annotationPadding + favoriteHeaderHeight + commentHeight + annotationPadding
            return height
    }

}
