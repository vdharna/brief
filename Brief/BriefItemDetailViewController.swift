//
//  BriefItemDetailViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 8/1/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class BriefItemDetailViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var toolbarView: UIView!
    @IBOutlet weak var postButton: UIButton!
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Comments"
        var toolbar = UIToolbar(frame: CGRectMake(0, self.view.frame.origin.y - 44, self.view.frame.width, 44))
        
        self.commentTextView.inputAccessoryView = toolbar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
