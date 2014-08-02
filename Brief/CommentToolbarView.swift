//
//  CommentToolbarView.swift
//  Brief
//
//  Created by Dharminder Dharna on 8/1/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class CommentToolbarView: UIView {

    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var postButton: UIButton!
    
    
    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        self.commentText.layer.cornerRadius = 5.0
        self.commentText.clipsToBounds = true
    }
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }


}
