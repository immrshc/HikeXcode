//
//  PinterestLayout.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2016/01/01.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit

/*
For this layout, you need to dynamically calculate the position and height of every item since you don’t know what the height of the photo or the annotation will be in advance. You’ll declare a protocol that will provide this position and height info when PinterestLayout needs it.
*/
protocol PinterestLayoutDelegate {
    // 1
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath,
        withWidth:CGFloat) -> CGFloat
    
    // 2
    func collectionView(collectionView: UICollectionView,
        heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
    
}

class PinterestLayoutAttributes: UICollectionViewLayoutAttributes {
    
    // 1 This declares the photoHeight property that the cell will use to resize its image view.
    var photoHeight: CGFloat = 0.0
    
    // 2 This overrides copyWithZone(). Subclasses of UICollectionViewLayoutAttributes need to conform to the NSCopying protocol because the attribute’s objects can be copied internally. You override this method to guarantee that the photoHeight property is set when the object is copied.
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone) as! PinterestLayoutAttributes
        copy.photoHeight = photoHeight
        return copy
    }
    
    // 3 This overrides isEqual(_:), and it’s mandatory as well. The collection view determines whether the attributes have changed by comparing the old and new attribute objects using isEqual(_:). You must implement it to compare the custom properties of your subclass. The code compares the photoHeight of both instances, and if they are equal, calls super to determine if the inherited attributes are the same. If the photo heights are different, it returns false.
    //アトリビュートが更新されたかどうか確認するために,写真の高さを比較する
    override func isEqual(object: AnyObject?) -> Bool {
        if let attributes = object as? PinterestLayoutAttributes {
            if( attributes.photoHeight == photoHeight  ) {
                return super.isEqual(object)
            }
        }
        return false
    }
}

//UICollectionViewLayoutを継承してコレクションビューのレイアウトを設定する
class PinterestLayout: UICollectionViewLayout {
    
    // 1 This keeps a reference to the delegate.
    var delegate: PinterestLayoutDelegate!
    
    // 2 These are two public properties for configuring the layout: the number of columns and the cell padding.
    var numberOfColumns = 2 //列の数
    var cellPadding: CGFloat = 6.0 //セルの余白
    
    // 3 This is an array to cache the calculated attributes. When you call prepareLayout(), you’ll calculate the attributes for all items and add them to the cache. When the collection view later requests the layout attributes, you can be efficient and query the cache instead of recalculating them every time.
    private var cache = [PinterestLayoutAttributes]()
    
    // 4  This declares two properties to store the content size. contentHeight is incremented as photos are added, and contentWidth is calculated based on the collection view width and its content inset.
    private var contentHeight: CGFloat  = 0.0 //写真が追加されるごとに増分される高さ
    private var contentWidth: CGFloat {//余白部分を差し引いた実質的な幅
        let insets = collectionView!.contentInset
        return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
    }
    
    /*
    This method is called whenever a layout operation is about to take place. It’s your opportunity to prepare and perform any calculations required to determine the collection view size and the positions of the items.
    */
    /*
    レイアウト処理が始まると、まず最初にレイアウトクラスのprepareLayoutが呼び出されます。このメソッドは、以降のレイアウト処理で必要となるレイアウト計算を全て事前に実行し、それぞれの要素のレイアウト情報をUICollectionViewLayoutAttributesに格納してキャッシュしておくことが目的です。
    */
    override func prepareLayout() {
        // 1 You only calculate the layout attributes if cache is empty.
        if cache.isEmpty {
            
            // 2 This declares and fills the xOffset array with the x-coordinate for every column based on the column widths. The yOffset array tracks the y-position for every column. You initialize each value in yOffset to 0, since this is the offset of the first item in each column.
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()//それぞれの列ごとの始めのx座標の位置の配列
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth )//それぞれの列ごとの始めのx座標の位置
            }
            var column = 0
            
            var yOffset = [CGFloat](count: numberOfColumns, repeatedValue: 0)
            
            // 3 This loops through all the items in the first section, as this particular layout has only one section.
            for item in 0 ..< collectionView!.numberOfItemsInSection(0) {
                
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                
                // 4 This is where you perform the frame calculation. width is the previously calculated cellWidth, with the padding between cells removed. You ask the delegate for the height of the image and the annotation, and calculate the frame height based on those heights and the predefined cellPadding for the top and bottom. You then combine this with the x and y offsets of the current column to create the insetFrame used by the attribute.
                let width = columnWidth - cellPadding * 2
                let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath,
                    withWidth:width)
                let annotationHeight = delegate.collectionView(collectionView!,
                    heightForAnnotationAtIndexPath: indexPath, withWidth: width)
                let height = cellPadding +  photoHeight + annotationHeight + cellPadding
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                //ある矩形から指定した余白分を除外した矩形を取得する
                let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
                
                // 5 This creates an instance of UICollectionViewLayoutAttribute, sets its frame using insetFrame and appends the attributes to cache.
                let attributes = PinterestLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.photoHeight = photoHeight
                attributes.frame = insetFrame
                cache.append(attributes)
                
                // 6 This expands contentHeight to account for the frame of the newly calculated item. It then advances the yOffset for the current column based on the frame. Finally, it advances the column so that the next item will be placed in the next column.
                contentHeight = max(contentHeight, CGRectGetMaxY(frame))
                yOffset[column] = yOffset[column] + height
                
                column = column >= (numberOfColumns - 1) ? 0 : ++column
            }
        }
    }
    /*
    UICollectionView内のスクロール領域の範囲をコントロールするコンテンツ部のサイズを返すメソッド
    */
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    /*
    Here you iterate through the attributes in cache and check if their frames intersect with rect, which is provided by the collection view. You add any attributes with frames that intersect with that rect to layoutAttributes, which is eventually returned to the collection view.
    */
    
    //引数で渡されたCGRectの範囲内に表示される要素のUICollectionViewLayoutAttributesの配列を返すメソッド
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if CGRectIntersectsRect(attributes.frame, rect) { //引数のCGRect同士が重なっていたらtrue
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    
    //引数で指定されたNSIndexPathに対応する補助要素のレイアウト情報を返すメソッドで、第一引数でフッターかヘッダーかを示す定数値が渡される
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = super.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath: indexPath)
        attributes!.frame = CGRect(x: 0, y: 0, width: collectionView!.bounds.size.width, height: 200)
        return attributes
    }
    
    /*
    This overrides layoutAttributesClass() to tell the collection view to use PinterestLayoutAttributes whenever it creates layout attributes objects.
    */
    override class func layoutAttributesClass() -> AnyClass {
        return PinterestLayoutAttributes.self
    }
    
}

