//
//  ExpressionView.swift
//  ReactionToolbar
//
//  Created by 1amageek on 2016/03/12.
//  Copyright © 2016年 Stamp inc. All rights reserved.
//

import UIKit

class ExpressionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
