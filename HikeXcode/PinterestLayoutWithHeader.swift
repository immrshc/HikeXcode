//
//  PinterestLayoutWithHeader.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2016/01/10.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit

class PinterestLayoutWithHeader: UICollectionViewLayout {
    
    var delegate: PinterestLayoutDelegate!
    var _layoutAttributes = Dictionary<String, PinterestLayoutAttributes>()
    var numberOfColumns = 2 //列の数
    var cellPadding:CGFloat = 6.0 //セルの余白
    var contentHeight:CGFloat = 80.0
    var contentWidth:CGFloat {
        let insets = collectionView!.contentInset
        return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
        _layoutAttributes = Dictionary<String, PinterestLayoutAttributes>() // 1
        //ここから
        let path = NSIndexPath(forItem: 0, inSection: 0)
        let attributes = PinterestLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: path)
        
        let headerHeight = CGFloat(130)
        attributes.frame = CGRectMake(0, 0, self.collectionView!.frame.size.width, headerHeight)
        
        let headerKey = layoutKeyForHeaderAtIndexPath(path)
        _layoutAttributes[headerKey] = attributes
        //ここまでが違う
        let numberOfSections = self.collectionView!.numberOfSections()
        
        for var section = 0; section < numberOfSections; section++ {
            
            let numberOfItems = self.collectionView!.numberOfItemsInSection(section)
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()
            //一方では、ここのheaderHeightが0になる
            var yOffset = [CGFloat](count: numberOfColumns, repeatedValue: headerHeight)
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth )//それぞれの列ごとの始めのx座標の位置
            }
            var column = 0
            
            for var item = 0; item < numberOfItems; item++ {
                
                let indexPath = NSIndexPath(forItem: item, inSection: section)
                //セルの幅
                let width = columnWidth - cellPadding * 2
                //セルの写真の高さ
                let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath, withWidth: width)
                //セルの投稿文とお気に入り部分の高さ
                let annotationHeight = delegate.collectionView(collectionView!,
                    heightForAnnotationAtIndexPath: indexPath, withWidth: width)
                //セル全体の高さ
                let height = cellPadding +  photoHeight + annotationHeight + cellPadding
                //セル全体のサイズ
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                //余白部分を無くしたセル全体のサイズ
                let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
                
                let attributes = PinterestLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.photoHeight = photoHeight
                attributes.frame = insetFrame
                let key = layoutKeyForIndexPath(indexPath)
                _layoutAttributes[key] = attributes
                
                //ここでCGRectGetMaxYを返さないとスクロールできない
                contentHeight = max(contentHeight, CGRectGetMaxY(frame))
                
                yOffset[column] = yOffset[column] + height
                column = column >= (numberOfColumns - 1) ? 0 : ++column
                
            }
            
        }
    }
    
    func layoutKeyForHeaderAtIndexPath(indexPath : NSIndexPath) -> String {
        return "s_\(indexPath.section)_\(indexPath.row)"
    }
    
    // MARK: -
    // MARK: Helpers
    func layoutKeyForIndexPath(indexPath : NSIndexPath) -> String {
        return "\(indexPath.section)_\(indexPath.row)"
    }
    
    // MARK:
    // MARK: Invalidate
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return !CGSizeEqualToSize(newBounds.size, self.collectionView!.frame.size)
    }
    
    // MARK: -
    // MARK: Required methods
    override func collectionViewContentSize() -> CGSize {
        //print("contentHeight: \(contentHeight)")
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let key = layoutKeyForIndexPath(indexPath)
        return _layoutAttributes[key]
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let headerKey = layoutKeyForIndexPath(indexPath)
        return _layoutAttributes[headerKey]
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let predicate = NSPredicate {  [unowned self] (evaluatedObject, bindings) -> Bool in
            let layoutAttribute = self._layoutAttributes[evaluatedObject as! String]
            return CGRectIntersectsRect(rect, layoutAttribute!.frame)
        }
        let dict = _layoutAttributes as NSDictionary
        let keys = dict.allKeys as NSArray
        let matchingKeys = keys.filteredArrayUsingPredicate(predicate)
        return dict.objectsForKeys(matchingKeys, notFoundMarker: NSNull()) as? [PinterestLayoutAttributes]
    }
}
