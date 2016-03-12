//
//  ReactionToolbar.swift
//  ReactionToolbar
//
//  Created by 1amageek on 2016/03/10.
//  Copyright © 2016年 Stamp inc. All rights reserved.
//

import UIKit

class ReactionToolbar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var itemSize: CGSize = CGSizeZero
    var contentInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
    var expressions: [AnyObject]? {
        didSet {
            let side: CGFloat = (self.bounds.width - contentInset.left - contentInset.right) / CGFloat((expressions?.count)!)
            self.itemSize = CGSize(width: side, height: side)
        }
    }
    
    var selectedIndexPath: NSIndexPath?
    var itemScale: CGFloat = 1.2 // 1 ~ 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.expressionView)
        self.addGestureRecognizer(self.panGestureRecognzier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        expressionView.frame = self.bounds
    }
    
    // MARK: - 
    
    lazy var panGestureRecognzier: UIPanGestureRecognizer = {
        var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panGesture:")
        return panGestureRecognizer
    }()
    
    func panGesture(recognizer: UIPanGestureRecognizer) {
        
        let location: CGPoint = recognizer.locationInView(self)
        
        if contentInset.left < location.x && location.x < (self.bounds.width - contentInset.right){
            let side: CGFloat = (self.bounds.width - contentInset.left - contentInset.right) / CGFloat((expressions?.count)!)
            let index: Int = Int((location.x - contentInset.left) / side)
            let indexPath: NSIndexPath = NSIndexPath(forItem: index, inSection: 0)
            if selectedIndexPath?.compare(indexPath) != NSComparisonResult.OrderedSame {
                self.selectedIndexPath = NSIndexPath(forItem: index, inSection: 0)
                UIView.animateWithDuration(0.33, animations: { () -> Void in
                    self.expressionView.collectionViewLayout.invalidateLayout()
                })
            }
        } else {
            guard let indexPath: NSIndexPath = self.selectedIndexPath else {
                return
            }
            if selectedIndexPath?.compare(indexPath) != NSComparisonResult.OrderedSame {
                self.selectedIndexPath = nil
                UIView.animateWithDuration(0.33, animations: { () -> Void in
                    self.expressionView.collectionViewLayout.invalidateLayout()
                })
            }
        }

    }
    
    // MARK: - expressionView
    
    lazy var expressionView: ExpressionView = {
        let frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 100)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        var expressionView: ExpressionView = ExpressionView(frame: frame, collectionViewLayout: layout)
        expressionView.allowsSelection = false
        expressionView.alwaysBounceHorizontal = false
        expressionView.alwaysBounceVertical = false
        expressionView.delegate = self
        expressionView.dataSource = self
        expressionView.registerClass(ExpressionViewCell.self, forCellWithReuseIdentifier: "ExpressionViewCell")
        return expressionView
    }()
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (expressions?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ExpressionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ExpressionViewCell", forIndexPath: indexPath) as! ExpressionViewCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return contentInset
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if selectedIndexPath == nil {
            return self.itemSize
        }
        
        if selectedIndexPath?.compare(indexPath) == NSComparisonResult.OrderedSame {
            return CGSize(width: itemSize.width * itemScale, height: itemSize.height * itemScale)
        }
        let side: CGFloat = (self.bounds.width - contentInset.left - contentInset.right - itemSize.width * itemScale) / CGFloat((expressions?.count)! - 1)
        return CGSizeMake(side, side)
    }
    
}
