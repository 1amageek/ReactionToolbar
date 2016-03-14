//
//  ExpressionLayout.swift
//  ReactionToolbar
//
//  Created by 1amageek on 2016/03/14.
//  Copyright © 2016年 Stamp inc. All rights reserved.
//

import UIKit

class ExpressionLayout: UICollectionViewFlowLayout {
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutAttributes: UICollectionViewLayoutAttributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath) else {
            return nil
        }
        layoutAttributes.alpha = 1
        return layoutAttributes
    }
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutAttributes: UICollectionViewLayoutAttributes = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath) else {
            return nil
        }
        layoutAttributes.alpha = 1
        return layoutAttributes
    }
    
}
