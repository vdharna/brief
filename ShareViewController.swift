//
//  ActionViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 9/7/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {

    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowOffset = CGSizeMake(0, 0)
        view.layer.shadowOpacity = 0.5
        
        shareLabel.layer.borderWidth = 1.0
        shareLabel.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        cancelButton.layer.borderWidth = 0.75
        cancelButton.layer.borderColor = UIColor.lightGrayColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelClicked(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)

    }
}
