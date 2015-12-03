//
//  AccountCollectionViewController.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/11/28.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import UIKit

class AccountCollectionViewController: UICollectionViewController {
    
    var postArray:[TimeLine] = []
    var refreshControl:UIRefreshControl!
    var selectedIndex:NSInteger!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ユーザIDに紐付いた自分の投稿を配列にする
        AccountTimeLineFetcher(selectedSegmentIndex: 0).download { (items) -> Void in
            self.postArray = items
            self.collectionView?.reloadData()
        }
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView!.addSubview(refreshControl)
    }
    
    func refresh(){
        AccountTimeLineFetcher(selectedSegmentIndex: selectedIndex).download { (items) -> Void in
            self.postArray = items
            self.refreshControl.endRefreshing()
            self.collectionView?.reloadData()
        }
    }
    
    @IBAction func postDo(sender: AnyObject) {
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PostNC")
            as? UINavigationController {
                self.presentViewController(vc, animated: true, completion: nil)
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
    addSubviewがないとstoryboad上のパーツと紐付かないので、タップに反応しない
    self.addSubview(changePostTapBtn)
    
    IBOutletはstoryboard上のパーツをオブジェクトにして変数に紐付ける
    この時、既にstoryboard上で存在するパーツはUIViewに加えられているのでaddSubviewは必要無い
    しかし、新しく追加したアクションはパーツに存在していないので、addSubviewで追加する必要がある
    */

    
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
    
    //セルのサイズ調整
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let screenSize = UIScreen.mainScreen().bounds
        let spaceWidth:CGFloat = 20
        let spaceHeight:CGFloat = 120
        let CGCellSize:CGSize = CGSizeMake((screenSize.size.width - spaceWidth)/2, (screenSize.size.height - spaceHeight)/2)
        
        return CGCellSize
    }

}
