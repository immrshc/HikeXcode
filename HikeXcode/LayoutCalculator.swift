//
//  LayoutCalculator.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2016/01/31.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit
import AVFoundation

class LayoutCalculator {
    //アスペクト比に応じた写真の高さを取得して、セルの写真の高さにする
    static func calculateHeightOfPhotoWithAspectRatio(cellWidth: CGFloat, imageSize: CGSize) -> CGFloat {
        let boundingRect =  CGRect(x: 0, y: 0, width: cellWidth, height: CGFloat(MAXFLOAT))
        let rect  = AVMakeRectWithAspectRatioInsideRect(imageSize, boundingRect)
        return rect.size.height
    }
    
    //投稿文の長さに応じて写真以外のセルの高さを調整する
    static func calculateHeightOfAnnotation(commentHeight: CGFloat) -> CGFloat {
        let annotationPadding = CGFloat(14) + CGFloat(5)
        let favoriteHeaderHeight = CGFloat(20)
        let height = annotationPadding + favoriteHeaderHeight + commentHeight
        return height
    }

}


