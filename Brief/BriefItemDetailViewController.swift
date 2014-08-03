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

    var toolbar: UIToolbar!
    var inputAccessoryToolbar: UIToolbar!
    
    var textView: UITextView!
    var inputAccessoryTextView: UITextView!
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setupTextViews()
        setupInputAccessoryToolbar()
        setupDockedToolbar()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Comments"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setupTextViews() {
        
        textView = UITextView(frame: CGRectMake(0, 0, 290, 30))
        inputAccessoryTextView = UITextView(frame: CGRectMake(0, 0, 215, 30))
        
        self.textView.delegate = self
        self.inputAccessoryTextView.delegate = self
        
        textView.layer.cornerRadius = 3.0
        textView.clipsToBounds = true
        
        inputAccessoryTextView.layer.cornerRadius = 3.0
        inputAccessoryTextView.clipsToBounds = true
        
        self.textView.text = "Enter Comment..."
        self.textView.textColor = UIColor.lightGrayColor()

    }
    
    func setupInputAccessoryToolbar() {
        
        // docked toolbar
        inputAccessoryToolbar = UIToolbar(frame: CGRectMake(0, 524, 320, 44))
        inputAccessoryToolbar.barTintColor = UIColor.blackColor()
        
        var cameraButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: Selector("attachFile"))
        cameraButton.tintColor = UIColor.whiteColor()
        
        // textview addition to toolbar
        var textViewButton = UIBarButtonItem(customView: inputAccessoryTextView)
        textViewButton.tintColor = UIColor.whiteColor()

        // post button
        var postButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("post"))

        postButton.tintColor = UIColor.whiteColor()

        inputAccessoryToolbar.setItems([cameraButton, textViewButton, postButton], animated: true)
        inputAccessoryToolbar.sizeToFit()
        
        
    }
    
    func setupDockedToolbar() {
        
        // docked toolbar
        toolbar = UIToolbar(frame: CGRectMake(0, 524, 320, 44))
        toolbar.barTintColor = UIColor.blackColor()
        
        // textview addition to toolbar
        var textViewButton = UIBarButtonItem(customView: textView)
        textViewButton.tintColor = UIColor.whiteColor()
        
        // setup the input accessory view
        self.textView.inputAccessoryView = inputAccessoryToolbar
        
        toolbar.setItems([textViewButton], animated: true)
        
        // add to subview
        self.view.addSubview(toolbar)
    }
    

    
    func textViewDidBeginEditing(textView: UITextView!) {
        if (textView == self.textView) {
            dispatch_async(dispatch_get_main_queue(), {
                self.inputAccessoryTextView.text = ""
                self.inputAccessoryTextView.becomeFirstResponder()
                })
        }
    }
    
    func textViewShouldBeginEditing(textView: UITextView!) -> Bool {
        
        if (textView == self.textView) {
            return !inputAccessoryTextView.isFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView!) {
        
        if (textView == inputAccessoryTextView) {
            self.textView.text = textView.text
        }
    }
    
    func textViewDidChange(textView: UITextView!) {
        var frame = textView.frame;
        var size = frame.size.height
        var inset = textView.contentInset
        frame.size.height = textView.contentSize.height + inset.top + inset.bottom
        var heightIncrement = frame.size.height - size
        if (heightIncrement != 0) {
            textView.frame = frame;
            
            //new height value for toolbar
            self.inputAccessoryToolbar.frame.size.height += heightIncrement
            //adjust the y value
            self.inputAccessoryToolbar.frame.origin.y -= heightIncrement
            
        }
        
    }
    
    @IBAction func post() {
        self.inputAccessoryTextView.text = ""
        self.inputAccessoryTextView.frame.size.height = 30
        self.inputAccessoryTextView.resignFirstResponder()
        
        self.textView.text = "Enter Comment..."
        self.textView.textColor = UIColor.lightGrayColor()
        
    }

    @IBAction func dismissKeyboard(sender: AnyObject) {
        
        self.inputAccessoryTextView.resignFirstResponder()
    }
}
