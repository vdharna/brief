//
//  BriefItemDetailViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 8/1/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class BriefItemDetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var table: UITableView!

    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var inputAccessoryToolbar: UIToolbar!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var inputAccessoryTextfield: UITextField!
    
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Comments"
//        self.commentTextView.layer.cornerRadius = 5.0
//        self.commentTextView.clipsToBounds = true
        
        
        self.inputAccessoryToolbar.removeFromSuperview() //needs to be assigned
        textField.inputAccessoryView = inputAccessoryToolbar
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardDidShowNotification, object: nil)
//        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField!) {
        println("textFieldDidBeginEditing: \(textField))")
        if (textField == self.textField) {
            dispatch_async(dispatch_get_main_queue(), {
                self.inputAccessoryTextfield.text = textField.text
                self.inputAccessoryTextfield.becomeFirstResponder()
                })
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField!) -> Bool {
        println("textFieldShouldBeginEditing: \(textField))")
        if (textField == self.textField) {
            return !inputAccessoryTextfield.isFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField!) {
        println("textFieldDidEndEditing: \(textField))")
        if (textField == inputAccessoryTextfield) {
            self.textField.text = textField.text
        }
        
    }
    
    @IBAction func post(sender: AnyObject) {
        self.inputAccessoryTextfield.resignFirstResponder()
        
    }
    
    
    
    
    
    
//    func keyboardWillHide(notification: NSNotification) {
//        
//        println("\(notification)")
//        var notificationInfo = notification.userInfo
//        var animationDuration = notificationInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
//        
//        // Animate view size synchronously with the appearance of the keyboard.
//        UIView.beginAnimations(nil, context: nil)
//        UIView.setAnimationDuration(animationDuration!)
//        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
//        
//        self.toolbarView.frame = CGRectMake(0, self.view.bounds.size.height - self.toolbarView.bounds.size.height, self.toolbarView.bounds.size.width, self.toolbarView.bounds.size.height)
//        
//        UIView.commitAnimations()
//
//    }
//    
//    func keyboardWillShow(notification: NSNotification) {
//        
//        println("\(notification)")
//        var notificationInfo = notification.userInfo
//        var animationDuration = notificationInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
//        var endFrame: CGRect = (notificationInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
//        
//        // Animate view size synchronously with the appearance of the keyboard.
//        UIView.beginAnimations(nil, context: nil)
//        UIView.setAnimationDuration(animationDuration!)
//        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
//        
//        self.toolbarView.frame = CGRectMake(0, endFrame.origin.y - self.toolbarView.bounds.size.height,self.toolbarView.bounds.size.width, self.toolbarView.bounds.size.height )
//                
//        UIView.commitAnimations()
//    }


}
