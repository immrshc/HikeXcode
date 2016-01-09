//
//  TestCollectionViewCell.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2016/01/09.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit

class TestCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postIV: UIImageView!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        if let attributes = TestLayout()._layoutAttributes["0_0"] {
            imageViewHeightLayoutConstraint.constant = attributes.size.height
        }
    }
    
}
