//
//  ReactionToolbar.swift
//  ReactionToolbar
//
//  Created by 1amageek on 2016/03/10.
//  Copyright © 2016年 Stamp inc. All rights reserved.
//

import UIKit

class ReactionToolbar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let toolbarHeight: CGFloat = 44
    let expressionViewHeight: CGFloat = 88
    
    var itemSize: CGSize = CGSizeZero
    var contentInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
    var expressions: [AnyObject]? {
        didSet {
            let side: CGFloat = (self.bounds.width - contentInset.left - contentInset.right) / CGFloat((expressions?.count)!)
            self.itemSize = CGSize(width: side, height: side)
        }
    }
    
    var selectedIndexPath: NSIndexPath?
    var itemScale: CGFloat = 1.5 // 1 ~ 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.grayColor()
        self.addSubview(self.toolbar)
        self.addGestureRecognizer(self.longPressGestureRecognzier)
        
        self.backgroundView.addSubview(self.expressionBackgroundView)
        self.backgroundView.addSubview(self.expressionView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.frame = CGRectMake(0, -expressionViewHeight, self.bounds.width, expressionViewHeight)
        expressionBackgroundView.frame = CGRect(x: self.contentInset.left, y: 0, width: self.bounds.size.width - self.contentInset.left - self.contentInset.right, height: self.itemSize.height)
        expressionBackgroundView.center = CGPointMake(backgroundView.bounds.width/2, backgroundView.bounds.height/2)
        expressionBackgroundView.layer.cornerRadius = self.itemSize.height/2
    }
    
    private lazy var toolbar: _TransparentToolbar = {
        var toolbar: _TransparentToolbar = _TransparentToolbar(frame: CGRect(x: 0, y: self.bounds.height - self.toolbarHeight, width: self.bounds.width, height: self.toolbarHeight))
        return toolbar
    }()
    
    // MARK: - Gesture recognizer
    
    lazy var longPressGestureRecognzier: UILongPressGestureRecognizer = {
        var longPressGestureRecognzier: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressGesture:")
        return longPressGestureRecognzier
    }()
    
    func longPressGesture(recognizer: UILongPressGestureRecognizer) {
        
        let location: CGPoint = recognizer.locationInView(self)
        let state: UIGestureRecognizerState = recognizer.state
        
        if state == UIGestureRecognizerState.Began {
            self.addSubview(self.backgroundView)
            self.expressionView.reloadData()
        }
        
        if state == UIGestureRecognizerState.Changed {
            if contentInset.left < location.x && location.x < (self.bounds.width - contentInset.right){
                let side: CGFloat = (self.bounds.width - contentInset.left - contentInset.right) / CGFloat((expressions?.count)!)
                let index: Int = Int((location.x - contentInset.left) / side)
                let indexPath: NSIndexPath = NSIndexPath(forItem: index, inSection: 0)
                if selectedIndexPath?.compare(indexPath) != NSComparisonResult.OrderedSame {
                    self.selectedIndexPath = NSIndexPath(forItem: index, inSection: 0)
                    UIView.animateWithDuration(0.33, animations: { () -> Void in
                        self.expressionView.collectionViewLayout.invalidateLayout()
                        self.setNeedsLayout()
                    })
                }
            } else {
                if selectedIndexPath != nil {
                    self.selectedIndexPath = nil
                    UIView.animateWithDuration(0.33, animations: { () -> Void in
                        self.expressionView.collectionViewLayout.invalidateLayout()
                    })
                }
            }
        }
        
        if state == UIGestureRecognizerState.Ended || state == UIGestureRecognizerState.Failed {
            guard let indexPath = selectedIndexPath else {
                return
            }
            print(indexPath)
            backgroundView.removeFromSuperview()
        }

    }
    
    // MARK: - Expression view
    
    lazy var backgroundView: UIView = {
        let frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.expressionViewHeight)
        var backgroundView: UIView = UIView(frame: frame)
        backgroundView.backgroundColor = UIColor.redColor()
        return backgroundView
    }()
    
    lazy var expressionBackgroundView: UIView = {
        let frame = CGRect(x: self.contentInset.left, y: 0, width: self.bounds.size.width - self.contentInset.left - self.contentInset.right, height: self.itemSize.height)
        var expressionBackgroundView: UIView = UIView(frame: frame)
        expressionBackgroundView.backgroundColor = UIColor.whiteColor()
        return expressionBackgroundView
    }()
    
    lazy var expressionView: ExpressionView = {
        let frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.expressionViewHeight)
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
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {

        cell.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, 44), CGAffineTransformMakeTranslation(0.85, 0.85))
        
        UIView.animateWithDuration(0.15, delay: 0.03 * Double(indexPath.item), options: [UIViewAnimationOptions.CurveEaseOut], animations: { () -> Void in
            cell.transform = CGAffineTransformIdentity
            }, completion: nil)
        
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

class _TransparentToolbar: UIToolbar {
    
    override func drawRect(rect: CGRect) {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = UIColor.clearColor()
//        self.opaque = false
//        self.translucent = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
