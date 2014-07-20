//
//  AddBriefViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/10/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class AddBriefViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var content: UITextView
    @IBOutlet var saveButton: UIBarButtonItem
    var charCountView: UIView = UIView()
    var charCountLabel: UILabel = UILabel()
    
    // ==========================================
    // MARK: lifecycle methods
    // ==========================================
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        println("<<< viewDidLoad >>>")
        content.delegate = self;
        content.returnKeyType = .Default
        content.keyboardAppearance = .Dark
        content.font = UIFont(name: "HelveticaNeue", size: 14)
        content.becomeFirstResponder()
        content.keyboardType = .ASCIICapable
        
        //configure the character count view
        charCountView.backgroundColor = UIColor.grayColor()
        self.view.addSubview(charCountView)
    }
    
    override func viewWillAppear(animated: Bool) {
        println("<<< viewWillAppear >>>")
        registerForKeyboardNotifications()
        updateCharacterCount()
    }
    
    override func viewWillDisappear(animated: Bool) {
        println("<<< viewWillDisappear >>>")
        content.resignFirstResponder()
        deregisterForKeyboardNotifications()
    }
    
    override func viewDidAppear(animated: Bool) {
        println("<<< viewDidAppear >>>")
    }

    override func viewDidDisappear(animated: Bool) {
        println("<<< viewDidDisappear >>>")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        println("<<< didReceiveMemoryWarning >>>")
    }
    
    
    // ===========================================
    // MARK: action methods
    // ===========================================
    @IBAction func dismissModal(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // ===========================================
    // MARK: Helper methods
    // ===========================================
    func updateCharacterCount() {
        //update the count character label
        println("<<< updateCharacterCount >>>")
        charCountLabel.text = (140 - content.text.utf16count).description
    }
    
    func toggleSaveButton() {
        
        if(!content.text.isEmpty) {
            saveButton.enabled = true;
        } else {
            saveButton.enabled = false
        }
    }
    
    
    // ===========================================
    // MARK: TextView Delegate methods
    // ===========================================
    func textViewShouldBeginEditing(textView: UITextView!) -> Bool {
        
        println("<<< textViewShouldBeginEditing >>>")
        return true
    }
    
    func textViewDidChange(textView: UITextView!) {
        println("<<< textViewDidChange >>>")
        
        updateCharacterCount()
        toggleSaveButton()
    }
    
    func textView(textView: UITextView!, shouldChangeTextInRange range: NSRange, replacementText text: String!) -> Bool {
        
        println("<<< textView shouldChangeTextInRange >>>")
        return true
    }
    
    // ===========================================
    // MARK: Keyboard notification methods
    // ===========================================
    
    func registerForKeyboardNotifications() {
        println("<<< registerForKeyboardNotifications >>>")
        var notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: "keyboardDidChangeFrame:", name: UIKeyboardDidChangeFrameNotification, object: nil)
        
    }
    
    func deregisterForKeyboardNotifications() {
        println("<<< deregisterForKeyboardNotifications >>>")
        var notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
    }
    
    
    // Called when the UIKeyboardDidShowNotification is sent.
    func keyboardWasShown(notification: NSNotification) {
        println("<<< keyboardWasShown >>>")
    }
    
    func keyboardWillChangeFrame(notification: NSNotification) {
        println("<<< keyboardWillChangeFrame >>>")
        
        var info: NSDictionary = notification.userInfo;
        var nsValue =  info.objectForKey(UIKeyboardFrameEndUserInfoKey) as NSValue
        var kbRect = nsValue.CGRectValue()
        drawCharacterCountLabel(kbRect)
    }
    
    func keyboardDidChangeFrame(notification: NSNotification) {
        println("<<< keyboardDidChangeFrame >>>")
    }
    
    func drawCharacterCountLabel(kbRect: CGRect) {
        println("<<< drawCharacterCountLabel >>>")
        
        let viewWidth: CGFloat = kbRect.width
        let viewHeight: CGFloat = 30;
        let x: CGFloat = 0
        let y: CGFloat = self.view.frame.height - (kbRect.height + viewHeight)
        var rect = CGRectMake(x, y, viewWidth, viewHeight)
        charCountView.frame = rect
        
        //configure the character count label here since you're redrawing the rect containing the container view (charCountView)
        let labelWidth: CGFloat = 40
        charCountLabel.textColor = UIColor.lightGrayColor()
        charCountLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        charCountLabel.backgroundColor = UIColor.grayColor()
        charCountLabel.frame = CGRectMake(charCountView.frame.width - labelWidth, 0, labelWidth, charCountView.frame.height)
        charCountView.addSubview(charCountLabel)
        
        
    }

}
