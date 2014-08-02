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
        self.commentTextView.layer.cornerRadius = 5.0
        self.commentTextView.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("adjustViewForKeyboardNotification:"), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("adjustViewForKeyboardNotification:"), name: UIKeyboardWillHideNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("adjustViewForKeyboardNotification:"), name: UIKeyboardDidChangeFrameNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("adjustViewForKeyboardNotification:"), name: UIKeyboardDidHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func adjustViewForKeyboardNotification(notification: NSNotification) {
        println("\(notification)")
        
        var notificationInfo = notification.userInfo
        
        // Get the end frame of the keyboard in screen coordinates.
        var finalKeyboardFrame: CGRect? = notificationInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
        
        // Convert the finalKeyboardFrame to view coordinates to take into account any rotation
        // factors applied to the window’s contents as a result of interface orientation changes.
        finalKeyboardFrame = self.view.convertRect(finalKeyboardFrame!, fromView: self.view.window)
        
        // Calculate new position of the toolbar
        var commentBarFrame = self.toolbarView.frame
        commentBarFrame.origin.y = finalKeyboardFrame!.origin.y - commentBarFrame.size.height
        
        // Update tableView height.
        var tableViewFrame = self.table.frame
        tableViewFrame.size.height = commentBarFrame.origin.y
        
        // Get the animation curve and duration
        //var animationCurve = (notificationInfo[UIKeyboardAnimationCurveUserInfoKey]?.integerValue)
        var animationDuration = notificationInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        
        // Animate view size synchronously with the appearance of the keyboard.
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration!)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        UIView.setAnimationBeginsFromCurrentState(true)
        
        self.toolbarView.frame = commentBarFrame
        self.table.frame = tableViewFrame
        
        UIView.commitAnimations()
        
        
        
    }
    

}
