//
//  AccountViewController.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2016/01/10.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit

class AccountViewController: ViewController, PinterestLayoutDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var selectedIndex:NSInteger!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.defaultCollectionView = collectionView
        
        //上に引っ張るとリロードされる動作の設定
        self.refreshContoll()
        
        //Pinterestのプロトコルを後で実装する
        if let layout = collectionView?.collectionViewLayout as? PinterestLayoutWithHeader {
            layout.delegate = self
        }

        //ユーザIDに紐付いた自分の投稿を配列にする
        AccountTimeLineFetcher(selectedSegmentIndex: 0).download { (items) -> Void in
            self.postArray = items
            self.collectionView?.reloadData()
        }
        
        //xibファイルを登録
        let nib = UINib(nibName: "AccountHeader", bundle: nil)
        collectionView.registerNib(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "AccountHeader")
        collectionView.reloadData()
    }
    
    //投稿画面へ遷移する
    @IBAction func postDo(sender: AnyObject) {
        self.showPost()
    }
    
    //上に引っ張ると投稿をリロードする
    override func refresh(){
        AccountTimeLineFetcher(selectedSegmentIndex: selectedIndex).download { (items) -> Void in
            self.postArray = items
            self.refreshControl.endRefreshing()
            self.collectionView?.reloadData()
        }
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
