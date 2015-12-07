//
//  TimeLineController.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/11/19.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import UIKit
import MapKit

class TimeLineController: UICollectionViewController {
    
    var postArray:[TimeLine] = []
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
       super.viewDidLoad()
        //imageがテンプレートにあると、ActionView::Template::Error ("\xFF" from ASCII-8BIT to UTF-8):がでる
        TimeLineFetcher().download { (items) -> Void in
            self.postArray = items
            self.collectionView?.reloadData()
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView!.addSubview(refreshControl)
        
    }
    
    @IBAction func postDo(sender: AnyObject) {
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PostNC")
            as? UINavigationController {
                self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func refresh(){
        TimeLineFetcher().download { (items) -> Void in
            self.postArray = items
            self.refreshControl.endRefreshing()
            self.collectionView?.reloadData()
        }
    }
    
    //セル数の指定
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.postArray.count
    }
    
    //セルの生成
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TimeLineCell", forIndexPath: indexPath) as! TimeLineCollectionViewCell
        cell.displayUpdate(postArray[indexPath.row])
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
    //collectionViewとcollectionViewCellの余白はSectionInsetsで調整する
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let screenSize = UIScreen.mainScreen().bounds
        let spaceWidth:CGFloat = 20
        let spaceHeight:CGFloat = 120
        let CGCellSize:CGSize = CGSizeMake((screenSize.size.width - spaceWidth)/2, (screenSize.size.height - spaceHeight)/2)
        
        return CGCellSize
    }
}

