//
//  PinterestLayoutWithHeader.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2016/01/10.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit

class PinterestLayoutWithHeader: PinterestLayout {
    override func prepareLayout() {
        super.prepareLayout()
        
        _layoutAttributes = Dictionary<String, PinterestLayoutAttributes>() // 1
        let path = NSIndexPath(forItem: 0, inSection: 0)
        let attributes = PinterestLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: path)
        
        let headerHeight = CGFloat(130)
        attributes.frame = CGRectMake(0, 0, self.collectionView!.frame.size.width, headerHeight)
        
        let headerKey = layoutKeyForHeaderAtIndexPath(path)
        _layoutAttributes[headerKey] = attributes
        
        let numberOfSections = self.collectionView!.numberOfSections()
        
        
        for var section = 0; section < numberOfSections; section++ {
            
            let numberOfItems = self.collectionView!.numberOfItemsInSection(section)
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()
            var yOffset = [CGFloat](count: numberOfColumns, repeatedValue: headerHeight)
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth )//それぞれの列ごとの始めのx座標の位置
            }
            var column = 0
            
            for var item = 0; item < numberOfItems; item++ {
                
                let indexPath = NSIndexPath(forItem: item, inSection: section)
                let width = columnWidth - cellPadding * 2
                let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath, withWidth: width)
                //print("photoHeight at PinterestLayoutWithHeader: \(photoHeight)")
                let annotationHeight = delegate.collectionView(collectionView!,
                    heightForAnnotationAtIndexPath: indexPath, withWidth: width)
                print("annotationHeight at PinterestLayoutWithHeader: \(annotationHeight)")
                let height = cellPadding +  photoHeight + annotationHeight + cellPadding
                print("height at PinterestLayoutWithHeader: \(height)")
                //let height = cellPadding +  height + cellPadding
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
                let attributes = PinterestLayoutAttributes(forCellWithIndexPath: indexPath)
                //attributes.size.width = width
                //attributes.size.height = height
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
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let headerKey = layoutKeyForIndexPath(indexPath)
        return _layoutAttributes[headerKey]
    }
}
