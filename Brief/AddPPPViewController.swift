//
//  AddBriefViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/10/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class AddPPPViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var content: UITextView!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    var charCountView: UIView = UIView()
    var charCountLabel: UILabel = UILabel()
    var selectedSegment: Int?
    var selectedPPPElement = -1 //default to indicate nothing is transitioned
    var snapshot:String?
    
    let characterLimit = 140

    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // ==========================================
    // MARK: lifecycle methods
    // ==========================================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //setup the content
        setupContent()
        //configure the character count view
        charCountView.backgroundColor = UIColor.grayColor()
        self.view.addSubview(charCountView)
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
            self.presentingViewController.dismissViewControllerAnimated(true, completion: {})
            
        } else {
            //set up the action sheets
            var alertVC = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            var cancelAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
                (value: UIAlertAction!) in
                self.content.becomeFirstResponder()
                println("") //need a line of code to make this work for some reason
                })
            
            var discardAlertAction = UIAlertAction(title: "Discard", style: .Destructive, handler: {
                (value: UIAlertAction!) in
                self.presentingViewController.dismissViewControllerAnimated(true, completion: {})

                })
            
            var saveAlertAction = UIAlertAction(title: "Save", style: .Destructive, handler: {
                (value: UIAlertAction!) in
                self.save(UIBarButtonItem())
                })
            
            alertVC.addAction(cancelAlertAction)
            alertVC.addAction(discardAlertAction)
            alertVC.addAction(saveAlertAction)
            
            self.presentViewController(alertVC, animated: true, completion: {
                () in
                self.content.resignFirstResponder()
                println("") //need a line of code to make this work for some reason
                })

        }
        
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        
        if (characterLimit - content.text.utf16Count < 0) {
            
            //set up the alert for characters over 140
            var alertVC = UIAlertController(title: "Over Limit", message: "Your status item is over 140 characters. Keep it brief. You can either edit it down or save it as a draft to fix later.", preferredStyle: UIAlertControllerStyle.Alert)
            
            var cancelAlertAction = UIAlertAction(title: "Edit", style: .Cancel, handler: {
                (value: UIAlertAction!) in
                self.content.becomeFirstResponder()
                println("") //need a line of code to make this work for some reason
                })
           
            var saveAlertAction = UIAlertAction(title: "Save", style: .Default, handler: {
                (value: UIAlertAction!) in
                self.saveItem()
                })
            
            alertVC.addAction(cancelAlertAction)
            alertVC.addAction(saveAlertAction)
            
            self.presentViewController(alertVC, animated: true, completion:  {
                () in
                self.content.resignFirstResponder()
                println("") //need a line of code to make this work for some reason
                })
        
        } else {
            
            saveItem()
        }

    }
    
    func saveItem() {
        
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
            self.presentingViewController.dismissViewControllerAnimated(true, completion: {})

        }
        
        self.presentingViewController.dismissViewControllerAnimated(true, completion: {})

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
        
        notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func deregisterForKeyboardNotifications() {
        var notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        self.charCountView.hidden = false
    }
    
    func keyboardWillChangeFrame(notification: NSNotification) {
        
        var info: NSDictionary = notification.userInfo;
        var nsValue =  info.objectForKey(UIKeyboardFrameEndUserInfoKey) as NSValue
        var kbRect = nsValue.CGRectValue()
        drawCharacterCountLabel(kbRect)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.charCountView.hidden = true
    }
    
    
    // ===========================================
    // MARK: View methods
    // ===========================================
    func drawCharacterCountLabel(kbRect: CGRect) {
        
        let viewWidth: CGFloat = kbRect.width
        let viewHeight: CGFloat = 30;
        let x: CGFloat = 0
        let y: CGFloat = self.view.frame.height - (kbRect.height + viewHeight)
        var rect = CGRectMake(x, y, viewWidth, viewHeight)
        self.charCountView.frame = rect
        
        //configure the character count label here since you're redrawing the rect containing the container view (charCountView)
        let labelWidth: CGFloat = 40
        self.charCountLabel.textColor = UIColor.lightGrayColor()
        self.charCountLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        self.charCountLabel.backgroundColor = UIColor.grayColor()
        self.charCountLabel.frame = CGRectMake(self.charCountView.frame.width - labelWidth, 0, labelWidth, self.charCountView.frame.height)
        self.charCountView.addSubview(self.charCountLabel)

    }
    
    func updateCharacterCount() {
        //update the count character label
        charCountLabel.text = (characterLimit - content.text.utf16Count).description
    }

}
