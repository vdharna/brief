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

    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var inputAccessoryToolbar: UIToolbar!
    
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    @IBOutlet weak var inputAccessoryBarButtonItem: UIBarButtonItem!
    
    var textView = UITextView(frame: CGRectMake(0, 0, 215, 28))
    var inputAccessoryTextView = UITextView(frame: CGRectMake(0, 0, 215, 28))
    
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Comments"
        setupTextViews()
        setupToolbars()

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
        self.textView.delegate = self
        self.inputAccessoryTextView.delegate = self
        
        textView.layer.cornerRadius = 3.0
        textView.clipsToBounds = true
        
        inputAccessoryTextView.layer.cornerRadius = 3.0
        inputAccessoryTextView.clipsToBounds = true
        
        self.inputAccessoryTextView.keyboardDismissMode = .OnDrag
        self.textView.keyboardDismissMode = .OnDrag

    }
    
    func setupToolbars() {
        
        self.barButtonItem.customView = self.textView
        self.inputAccessoryBarButtonItem.customView = self.inputAccessoryTextView
        
        self.inputAccessoryToolbar.removeFromSuperview() //needs to be assigned
        self.textView.inputAccessoryView = inputAccessoryToolbar
        
    }
    
    func textViewDidBeginEditing(textView: UITextView!) {
        if (textView == self.textView) {
            dispatch_async(dispatch_get_main_queue(), {
                self.inputAccessoryTextView.text = textView.text
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
        println("\(frame.size.height)")
        var size = frame.size.height
        var inset = textView.contentInset
        frame.size.height = textView.contentSize.height + inset.top + inset.bottom
        println("\(frame.size.height)")
        var newSize = frame.size.height
        if (newSize - size != 0) {
            textView.frame = frame;
            
            //new height value for toolbar
            self.inputAccessoryToolbar.frame.size.height += newSize - size
            //adjust the y value
            self.inputAccessoryToolbar.frame.origin.y -= newSize - size
            
        }
        
    }
    
    
    @IBAction func post(sender: AnyObject) {
        self.inputAccessoryTextView.text = ""
        self.inputAccessoryTextView.frame.size.height = 30
        self.inputAccessoryTextView.resignFirstResponder()
        
    }

    @IBAction func dismissKeyboard(sender: AnyObject) {
        
        self.inputAccessoryTextView.resignFirstResponder()
    }
}
