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
        var reactionToolbar: ReactionToolbar = ReactionToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100))
        reactionToolbar.expressions = [0,1,2,3,4,5]
        return reactionToolbar
    }()
    
    override func loadView() {
        super.loadView()
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

