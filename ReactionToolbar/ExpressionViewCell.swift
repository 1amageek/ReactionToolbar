//
//  Expession.swift
//  ReactionToolbar
//
//  Created by 1amageek on 2016/03/11.
//  Copyright © 2016年 Stamp inc. All rights reserved.
//

import UIKit

class ExpressionViewCell: UICollectionViewCell {
    
    lazy var expressionView: UIView = {
        let frame = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(3, 1.5, 3, 1.5))
        var expressionView: UIView = UIView(frame: frame)
        expressionView.backgroundColor = UIColor.greenColor()
        expressionView.layer.cornerRadius = frame.size.width/2
        expressionView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        return expressionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.expressionView)
        self.backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let frame: CGRect = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(3, 3, 3, 3))
        self.expressionView.frame = frame
        expressionView.layer.cornerRadius = frame.size.width/2
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        layoutAttributes.alpha = 1
        let frame: CGRect = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(3, 3, 3, 3))
        self.expressionView.frame = frame
        expressionView.layer.cornerRadius = frame.size.width/2
    }
}
