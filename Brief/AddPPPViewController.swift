//
//  AddBriefViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/10/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class AddPPPViewController: UIViewController, UITextViewDelegate, UIActionSheetDelegate {

    @IBOutlet var content: UITextView!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    var charCountView: UIView = UIView()
    var charCountLabel: UILabel = UILabel()
    var selectedSegment: Int?
    var selectedPPPElement = -1 //default to indicate nothing is transitioned
    var snapshot:String?
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // ==========================================
    // MARK: lifecycle methods
    // ==========================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup the content
        setupContent()
        
        //configure the character count view
        charCountView.backgroundColor = UIColor.grayColor()
        self.view.addSubview(charCountView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setContentForEdit()
        registerForKeyboardNotifications()
        updateCharacterCount()
        //take snapshot for comparison
        snapshot = content.text
    
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
        deregisterForKeyboardNotifications()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupContent() {
        // Do any additional setup after loading the view.
        content.delegate = self;
        content.returnKeyType = .Default
        content.keyboardAppearance = .Dark
        content.font = UIFont(name: "HelveticaNeue", size: 14)
        content.becomeFirstResponder()
        content.keyboardType = .ASCIICapable
    }
    
    
    // ===========================================
    // MARK: action methods
    // ===========================================
    @IBAction func dismissModal(sender: UIButton) {
        
        if(snapshot == content.text) {
            self.presentingViewController.dismissViewControllerAnimated(true, completion: nil)
        } else {
            var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Discard" )
            actionSheet.addButtonWithTitle("Save")
            actionSheet.actionSheetStyle = UIActionSheetStyle.BlackOpaque
            //actionSheet.showInView(UIApplication.sharedApplication().keyWindow)
            self.content.resignFirstResponder()
            self.charCountView.hidden = true
            actionSheet.showInView(self.view)
        }
        
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        //create the correct model object
        var editMode = selectedPPPElement > -1
        switch (selectedSegment!) {
            
        case 0:
            var progress = Progress(content: content.text)
            if (editMode) {
                user.brief.updateProgress(selectedPPPElement, p: progress)
            } else {
                user.brief.addProgress(progress)
            }
            
        case 1:
            var plan = Plan(content: content.text)
            if (editMode) {
                user.brief.updatePlan(selectedPPPElement, p: plan)
            } else {
                user.brief.addPlan(plan)
            }
            
        case 2:
            var problem = Problem(content: content.text)
            if (editMode) {
                user.brief.updateProblem(selectedPPPElement, p: problem)
            } else {
                user.brief.addProblem(problem)
            }
            
        default:
            self.presentingViewController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // ===========================================
    // MARK: action sheet delegation method
    // ===========================================
    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {

        switch(buttonIndex) {
        
        case 0: //discard
            self.presentingViewController.dismissViewControllerAnimated(true, completion: nil)

        case 1: //cancel
            self.content.becomeFirstResponder()
            self.charCountView.hidden = false
            
        case 2:
            self.save(cancelButton) //save the information
            
        default:
            break
        }
        
    }
    
    
    // ===========================================
    // MARK: Helper methods
    // ===========================================
    
    func toggleSaveButton() {
        if(!content.text.isEmpty) {
            saveButton.enabled = true;
        } else {
            saveButton.enabled = false
        }
    }
    
    func setContentForEdit() {
        if (selectedPPPElement > -1) { //something was passed for edit
            switch (selectedSegment!) {
                
            case 0:
                content.text = user.brief.progress[selectedPPPElement].getContent()

            case 1:
                content.text = user.brief.plans[selectedPPPElement].getContent()
                
            case 2:
                content.text = user.brief.problems[selectedPPPElement].getContent()
                
            default:
                content.text = ""
            }
        }
    }
    
    
    // ===========================================
    // MARK: TextView Delegate methods
    // ===========================================
    func textViewShouldBeginEditing(textView: UITextView!) -> Bool {
        return true
    }
    
    func textViewDidChange(textView: UITextView!) {
        updateCharacterCount()
        toggleSaveButton()
    }
    
    func textView(textView: UITextView!, shouldChangeTextInRange range: NSRange, replacementText text: String!) -> Bool {
        
        return true
    }
    
    // ===========================================
    // MARK: Keyboard notification methods
    // ===========================================
    
    func registerForKeyboardNotifications() {
        var notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardDidChangeFrame:", name: UIKeyboardDidChangeFrameNotification, object: nil)
        
    }
    
    func deregisterForKeyboardNotifications() {
        var notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
    }
    
    
    // Called when the UIKeyboardDidShowNotification is sent.
    func keyboardWasShown(notification: NSNotification) {
    }
    
    func keyboardWillChangeFrame(notification: NSNotification) {
        
        var info: NSDictionary = notification.userInfo;
        var nsValue =  info.objectForKey(UIKeyboardFrameEndUserInfoKey) as NSValue
        var kbRect = nsValue.CGRectValue()
        drawCharacterCountLabel(kbRect)
    }
    
    func keyboardDidChangeFrame(notification: NSNotification) {
    }
    
    func drawCharacterCountLabel(kbRect: CGRect) {
        
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
    
    func updateCharacterCount() {
        //update the count character label
        charCountLabel.text = (140 - content.text.utf16Count).description
    }

}
