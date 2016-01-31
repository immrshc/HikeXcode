//
//  AccountViewController.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2016/01/10.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit

class AccountViewController: ViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var selectedIndex:NSInteger!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //xibファイルを登録
        let nib = UINib(nibName: "AccountHeader", bundle: nil)
        collectionView.registerNib(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "AccountHeader")
        collectionView.reloadData()
    }
    
    override func getTimeLine(){
        AccountTimeLineFetcher(selectedSegmentIndex: 0).download { (items) -> Void in
            self.postArray = items
            self.collectionView?.reloadData()
        }
    }
    
    override func setCollectionView() -> UICollectionView! {
        return collectionView
    }
    
    override func setDelegateOfLayout(){
        if let layout = collectionView?.collectionViewLayout as? PinterestLayoutWithHeader {
            layout.delegate = self
        }
    }
    
    //上に引っ張ると投稿をリロードする
    override func refresh(){
        AccountTimeLineFetcher(selectedSegmentIndex: 0).download { (items) -> Void in
            self.postArray = items
            self.refreshControl.endRefreshing()
            self.collectionView?.reloadData()
        }
    }
    
    //投稿画面へ遷移する
    @IBAction func postDo(sender: AnyObject) {
        self.showPost()
    }
    
    //ヘッダーをXibファイルから生成
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "AccountHeader", forIndexPath: indexPath) as! AccountHeaderReusableView
        header.displayUpdate()
        let changePostTapBtn:UISegmentedControl = header.changePostTapBtn
        self.selectedIndex = changePostTapBtn.selectedSegmentIndex
        changePostTapBtn.addTarget(self, action: "postUpdate:", forControlEvents: UIControlEvents.ValueChanged)
        header.addSubview(changePostTapBtn)
        return header
        
    }
    
    //選択されたタブのインデックスで表示を変更する
    func postUpdate(segcon: UISegmentedControl){
        self.selectedIndex = segcon.selectedSegmentIndex
        AccountTimeLineFetcher(selectedSegmentIndex: selectedIndex).download { (items) -> Void in
            self.postArray = items
            self.collectionView?.reloadData()
        }
    }
    
    //アスペクト比に応じた写真の高さを取得して、セルの写真の高さにする
    override func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath,
        withWidth width: CGFloat) -> CGFloat {
            let post = postArray[indexPath.row]
            let imageSize = post.imageInfo?.size
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
