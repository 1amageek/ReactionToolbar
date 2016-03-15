//
//  ReactionToolbar.swift
//  ReactionToolbar
//
//  Created by 1amageek on 2016/03/10.
//  Copyright © 2016年 Stamp inc. All rights reserved.
//

import UIKit

class ReactionToolbar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    let toolbarHeight: CGFloat = 44
    let expressionViewHeight: CGFloat = 120
    var animationDuration: NSTimeInterval = 0.18
    
    var reactionBarButtonItem: ReactionBarButtonItem?
    var translucent: Bool = false
    var items: [UIBarButtonItem]? {
        
        get {
            return self.toolbar.items
        }
        
        set(items) {
            self.setItems(items, animated: false)
        }
        
    }
    func setItems(items: [UIBarButtonItem]?, animated: Bool) {
        self.toolbar.setItems(items, animated: animated)
        for (_, barButtonItem) in (items?.enumerate())! {
            if barButtonItem.isKindOfClass(ReactionBarButtonItem.self) {
                self.reactionBarButtonItem = barButtonItem as? ReactionBarButtonItem
            }
        }
    }
    
    var itemSize: CGSize = CGSizeZero
    var contentInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
    var sectionContentInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 32, right: 3)
    var backgroundContentInset: UIEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    var expressions: [AnyObject]? {
        didSet {
            let numberOfExpressions: CGFloat = CGFloat((expressions?.count)!)
            let side: CGFloat = floor(((self.bounds.width - contentInset.left - contentInset.right) - ((sectionContentInset.right + sectionContentInset.left) * numberOfExpressions)) / numberOfExpressions)
            self.itemSize = CGSize(width: side, height: side)
        }
    }
    
    var selectedIndexPath: NSIndexPath?
    var itemScale: CGFloat = 1.7 // 1 ~ 1.5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
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
        let width: CGFloat = self.bounds.size.width - self.contentInset.left - self.contentInset.right + self.backgroundContentInset.left + self.backgroundContentInset.right
        let height: CGFloat = self.backgroundContentInset.top + self.itemSize.height + self.backgroundContentInset.bottom
        expressionBackgroundView.frame = CGRect(x: self.contentInset.left - self.backgroundContentInset.left, y: backgroundView.bounds.height - height - sectionContentInset.bottom + backgroundContentInset.top, width: width, height: height)
        expressionBackgroundView.layer.cornerRadius = height/2
    }
    
    lazy var toolbar: UIToolbar = {
        var toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: self.bounds.height - self.toolbarHeight, width: self.bounds.width, height: self.toolbarHeight))
        return toolbar
    }()
    
    // MARK: - Gesture recognizer
    
    lazy var longPressGestureRecognzier: UILongPressGestureRecognizer = {
        var longPressGestureRecognzier: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressGesture:")
        longPressGestureRecognzier.delegate = self
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
                let indexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: index)
                
                if selectedIndexPath == nil {
                    let numberOfExpressions: CGFloat = CGFloat((expressions?.count)! - 1)
                    let side: CGFloat = floor(((self.bounds.width - contentInset.left - contentInset.right) - ((sectionContentInset.right + sectionContentInset.left) * numberOfExpressions) - (itemSize.width + self.sectionContentInset.left + self.sectionContentInset.right) * itemScale) / numberOfExpressions)
                    let width: CGFloat = self.bounds.size.width - self.contentInset.left - self.contentInset.right + self.backgroundContentInset.left + self.backgroundContentInset.right
                    let height: CGFloat = self.backgroundContentInset.top + side + self.backgroundContentInset.bottom
                    UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                        self.expressionBackgroundView.frame = CGRect(x: self.contentInset.left - self.backgroundContentInset.left, y: self.backgroundView.bounds.height - height - self.sectionContentInset.bottom + self.backgroundContentInset.top, width: width, height: height)
                        self.expressionBackgroundView.layer.cornerRadius = height/2
                    })
                }
                
                if selectedIndexPath?.compare(indexPath) != NSComparisonResult.OrderedSame {
                    self.selectedIndexPath = indexPath
                    UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                        self.expressionView.collectionViewLayout.invalidateLayout()
                    })
                }
            } else {
                if selectedIndexPath != nil {
                    self.selectedIndexPath = nil
                    UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                        self.expressionView.collectionViewLayout.invalidateLayout()
                    })
                    
                    UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                        let width: CGFloat = self.bounds.size.width - self.contentInset.left - self.contentInset.right + self.backgroundContentInset.left + self.backgroundContentInset.right
                        let height: CGFloat = self.backgroundContentInset.top + self.itemSize.height + self.backgroundContentInset.bottom
                        self.expressionBackgroundView.frame = CGRect(x: self.contentInset.left - self.backgroundContentInset.left, y: self.backgroundView.bounds.height - height - self.sectionContentInset.bottom + self.backgroundContentInset.top, width: width, height: height)
                        self.expressionBackgroundView.layer.cornerRadius = height/2
                    })
                }
            }
        }
        
        if state == UIGestureRecognizerState.Ended || state == UIGestureRecognizerState.Failed || state == UIGestureRecognizerState.Cancelled {
            
            UIView.animateWithDuration(0.33, animations: { () -> Void in
                self.expressionBackgroundView.transform = CGAffineTransformMakeTranslation(0, 44)
                self.expressionBackgroundView.alpha = 0
            })
            
            let visibleCells = self.expressionView.visibleCells()
            for (index, cell) in visibleCells.enumerate() {
                cell.transform = CGAffineTransformIdentity
                if index == selectedIndexPath?.item {
                    UIView.animateWithDuration(animationDuration, delay: 0, options: [UIViewAnimationOptions.CurveEaseOut], animations: { () -> Void in
                        cell.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, -100), CGAffineTransformMakeScale(0.1, 0.1))
                        cell.alpha = 0
                        }, completion: { (finished) -> Void in
                            
                            if index == (visibleCells.count - 1) {
                                self.backgroundView.removeFromSuperview()
                                self.expressionBackgroundView.transform = CGAffineTransformIdentity
                                self.expressionBackgroundView.alpha = 1
                                self.selectedIndexPath = nil
                            }
                            
                    })
                } else {
                    UIView.animateWithDuration(animationDuration, delay: 0.02 * Double(index), options: [UIViewAnimationOptions.CurveEaseOut], animations: { () -> Void in
                        cell.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, 100), CGAffineTransformMakeScale(0.1, 0.1))
                        cell.alpha = 0
                        }, completion: { (finished) -> Void in
                            
                            if index == (visibleCells.count - 1) {
                                self.backgroundView.removeFromSuperview()
                                self.expressionBackgroundView.transform = CGAffineTransformIdentity
                                self.expressionBackgroundView.alpha = 1
                                self.selectedIndexPath = nil
                            }
                            
                    })
                }
            }
        }
    }
    
    // MARK: - Expression view
    
    lazy var backgroundView: UIView = {
        let frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.expressionViewHeight)
        var backgroundView: UIView = UIView(frame: frame)
        backgroundView.backgroundColor = UIColor.clearColor()
        backgroundView.clipsToBounds = false
        return backgroundView
    }()
    
    lazy var expressionBackgroundView: UIView = {
        let frame = CGRect(x: self.contentInset.left, y: 0, width: self.bounds.size.width - self.contentInset.left - self.contentInset.right, height: self.itemSize.height)
        var expressionBackgroundView: UIView = UIView(frame: frame)
        expressionBackgroundView.backgroundColor = UIColor.whiteColor()
        expressionBackgroundView.clipsToBounds = false
//        expressionBackgroundView.layer.shadowRadius = 15
//        expressionBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        expressionBackgroundView.layer.shadowColor = UIColor.blackColor().CGColor
        return expressionBackgroundView
    }()
    
    lazy var expressionView: ExpressionView = {
        let frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.expressionViewHeight)
        let layout: ExpressionLayout = ExpressionLayout()
        layout.scrollDirection = .Horizontal
        var expressionView: ExpressionView = ExpressionView(frame: frame, collectionViewLayout: layout)
        expressionView.allowsSelection = false
        expressionView.alwaysBounceHorizontal = false
        expressionView.alwaysBounceVertical = false
        expressionView.delegate = self
        expressionView.dataSource = self
        expressionView.contentInset = self.contentInset
        expressionView.registerClass(ExpressionViewCell.self, forCellWithReuseIdentifier: "ExpressionViewCell")
        return expressionView
    }()
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return (expressions?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ExpressionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ExpressionViewCell", forIndexPath: indexPath) as! ExpressionViewCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        cell.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, 88), CGAffineTransformMakeScale(0.3, 0.3))
        UIView.animateWithDuration(0.3, delay: 0.02 * Double(indexPath.item), options: [UIViewAnimationOptions.CurveEaseOut], animations: { () -> Void in
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
        
        let indexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: section)
        
        if selectedIndexPath != nil {
            if selectedIndexPath?.compare(indexPath) == NSComparisonResult.OrderedSame {
                let side = floor((itemSize.width + self.sectionContentInset.left + self.sectionContentInset.right) * itemScale)
                let top: CGFloat = self.expressionView.bounds.height - side - self.sectionContentInset.bottom
                return UIEdgeInsetsMake(top, 0, self.sectionContentInset.bottom, 0)
            }
            
            let numberOfExpressions: CGFloat = CGFloat((expressions?.count)! - 1)
            let side: CGFloat = floor(((self.bounds.width - contentInset.left - contentInset.right) - ((sectionContentInset.right + sectionContentInset.left) * numberOfExpressions) - (itemSize.width + self.sectionContentInset.left + self.sectionContentInset.right) * itemScale) / numberOfExpressions)
            let top: CGFloat = self.expressionView.bounds.height - side - self.sectionContentInset.bottom
            return UIEdgeInsetsMake(top, self.sectionContentInset.right, self.sectionContentInset.bottom, self.sectionContentInset.right)
            
        }

        let top: CGFloat = self.expressionView.bounds.height - self.itemSize.height - self.sectionContentInset.bottom
        return UIEdgeInsetsMake(top, self.sectionContentInset.right, self.sectionContentInset.bottom, self.sectionContentInset.right)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if selectedIndexPath == nil {
            return self.itemSize
        }
        
        if selectedIndexPath?.compare(indexPath) == NSComparisonResult.OrderedSame {
            let side = floor((itemSize.width + self.sectionContentInset.left + self.sectionContentInset.right) * itemScale)
            return CGSize(width: side, height: side)
        }
        let numberOfExpressions: CGFloat = CGFloat((expressions?.count)! - 1)
        let side: CGFloat = floor(((self.bounds.width - contentInset.left - contentInset.right) - ((sectionContentInset.right + sectionContentInset.left) * numberOfExpressions) - (itemSize.width + self.sectionContentInset.left + self.sectionContentInset.right) * itemScale) / numberOfExpressions)
        return CGSize(width: side, height: side)
    }
    
    // MARK: - UIGestureRecognizer
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location: CGPoint = gestureRecognizer.locationInView(self)
        guard let barButtonItem = self.reactionBarButtonItem else {
            return false
        }
        if CGRectContainsPoint((barButtonItem.customView?.frame)!, location) {
            return true
        }
        return false
    }
    
}

class _TransparentToolbar: UIToolbar {
    
//    override var translucent: Bool {
//        didSet {
//            if translucent {
//                self.backgroundColor = UIColor.clearColor()
//                self.opaque = false
//            }
//        }
//    }
    
    override func drawRect(rect: CGRect) {
        if translucent {
            
        } else {
            super.drawRect(rect)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.opaque = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
