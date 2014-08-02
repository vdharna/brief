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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    @IBAction func postComment(sender: AnyObject) {
        self.commentTextView.resignFirstResponder()
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        
        println("\(notification)")
        var notificationInfo = notification.userInfo
        var animationDuration = notificationInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        
        // Animate view size synchronously with the appearance of the keyboard.
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration!)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        
        self.toolbarView.frame = CGRectMake(0, self.view.bounds.size.height - self.toolbarView.bounds.size.height, self.toolbarView.bounds.size.width, self.toolbarView.bounds.size.height)
        
        UIView.commitAnimations()

    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        println("\(notification)")
        var notificationInfo = notification.userInfo
        var animationDuration = notificationInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        var endFrame: CGRect = (notificationInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        
        // Animate view size synchronously with the appearance of the keyboard.
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration!)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        
        self.toolbarView.frame = CGRectMake(0, endFrame.origin.y - self.toolbarView.bounds.size.height,self.toolbarView.bounds.size.width, self.toolbarView.bounds.size.height )
        
        UIView.commitAnimations()
    }


}
