//
//  TimeLineController.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/11/19.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TimeLineController: UICollectionViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var postArray:[TimeLine] = []
    
    override func viewDidLoad() {
       super.viewDidLoad()
        TimeLineFetcher().download { (items) -> Void in
            self.postArray = items
            self.collectionView?.reloadData()
        }
    }
    
    //セル数の指定
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Number:\(self.postArray.count)")
        return self.postArray.count
    }
    
    //セルの生成
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TimeLineCell", forIndexPath: indexPath) as! TimeLineCollectionViewCell
        print("indexPath.row:\(indexPath.row)")
        cell.displayUpdate(postArray[indexPath.row])
        return cell
    }
    
    //詳細画面への遷移
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
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

