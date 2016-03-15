//
//  ViewController.swift
//  ReactionToolbar
//
//  Created by 1amageek on 2016/03/10.
//  Copyright © 2016年 Stamp inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var reactionToolbar: ReactionToolbar = {
        var reactionToolbar: ReactionToolbar = ReactionToolbar(frame: CGRect(x: 0, y: self.view.bounds.height - 44, width: self.view.bounds.width, height: 44))
        reactionToolbar.expressions = [0,1,2,3,4,5]
        reactionToolbar.setItems([self.likeBarButtonItem], animated: false)
        return reactionToolbar
    }()

    var likeView: UIView = {
        var view = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        view.backgroundColor = UIColor.redColor()
        return view
    }()
    
    lazy var likeBarButtonItem: ReactionBarButtonItem = {
        var likeBarButtonItem: ReactionBarButtonItem = ReactionBarButtonItem(customView: self.likeView)
        return likeBarButtonItem
    }()
    
    override func loadView() {
        super.loadView()
        let imageView: UIImageView = UIImageView(image: UIImage(named: "background.jpg"))
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.frame = self.view.bounds
        self.view.addSubview(imageView)
        self.view.addSubview(self.reactionToolbar)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

