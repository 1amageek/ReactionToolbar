//
//  Expession.swift
//  ReactionToolbar
//
//  Created by 1amageek on 2016/03/11.
//  Copyright © 2016年 Stamp inc. All rights reserved.
//

import UIKit

class ExpressionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let frame = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsZero)
        let path = UIBezierPath(ovalInRect: frame)
        UIColor.yellowColor().setFill()
        path.fill()
        
    }
}
