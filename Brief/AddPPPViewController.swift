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
    var itemDescription: UILabel!
    
    var saveButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    
    var charCountView: CharacterCountView!
    var selectedSegment: Int?
    var selectedPPPElement = -1 //default to indicate nothing is transitioned
    var snapshot:String?
    
    let progressDescription = "List an accomplishment, finished item or closed task for the current reporting period..."
    let planDescription = "List a goal or objective for the next reporting period..."
    let problemDescription = "List an item you can't finish and need escalation or help from someone else..."
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    // ==========================================
    // MARK: lifecycle methods
    // ==========================================
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        itemDescription = UILabel(frame: CGRectMake(3, 0, 320, 50))
        itemDescription.font = UIFont(name: "Helvetica", size: 14)
        itemDescription.numberOfLines = 3
        itemDescription.textColor = UIColor.lightGrayColor()
        self.content.addSubview(itemDescription)
        
        //configure the character count view
        setupCharacterCountLabel()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //setup the content
        setupContent()

        setContentForEdit()
        self.charCountView.updateCharacterCount(content.text.utf16Count)
        //take snapshot for comparison
        snapshot = content.text
    
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
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
    
    func setupNavigationBar() {
        
        saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: Selector("save:"))
        cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("dismissModal:"))
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.title = "Compose"
        
        self.automaticallyAdjustsScrollViewInsets = false
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
            if(!content.text.isEmpty) {
                // dont allow save if they empty content - it will create blank cell
                alertVC.addAction(saveAlertAction)
            }
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
                user.getBrief().updateProgress(selectedPPPElement, p: progress)
            } else {
                user.getBrief().addProgress(progress)
            }
            
        case 1:
            var plan = Plan(content: content.text)
            if (editMode) {
                user.getBrief().updatePlan(selectedPPPElement, p: plan)
            } else {
                user.getBrief().addPlan(plan)
            }
            
        case 2:
            var problem = Problem(content: content.text)
            if (editMode) {
                user.getBrief().updateProblem(selectedPPPElement, p: problem)
            } else {
                user.getBrief().addProblem(problem)
            }
            
        default:
            self.presentingViewController.dismissViewControllerAnimated(true, completion: {})

        }
        
        self.presentingViewController.dismissViewControllerAnimated(true, completion: {})

    }
    
    // ===========================================
    // MARK: Helper methods
    // ===========================================
    
    
    func setContentForEdit() {
        if (selectedPPPElement > -1) { //something was passed for edit
            switch (selectedSegment!) {
                
            case 0:
                content.text = user.getBrief().progress[selectedPPPElement].getContent()

            case 1:
                content.text = user.getBrief().plans[selectedPPPElement].getContent()
                
            case 2:
                content.text = user.getBrief().problems[selectedPPPElement].getContent()
                
            default:
                content.text = ""
            }
        }
    }
    
    
    func setupLabelDescription() {
        
        switch (selectedSegment!) {
            
        case 0:
            self.itemDescription.text = self.progressDescription
            
        case 1:
            self.itemDescription.text = self.planDescription
            
        case 2:
            self.itemDescription.text = self.problemDescription
            
        default:
            content.text = ""
        }
    }
    
    // ===========================================
    // MARK: TextView Delegate methods
    // ===========================================
    
    func textViewDidChange(textView: UITextView!) {
        
        if (!self.itemDescription.hidden) {
            self.itemDescription.hidden = true
        }
        if (content.text.utf16Count == 0) {
            self.itemDescription.hidden = false
        }
        
        self.charCountView.updateCharacterCount(content.text.utf16Count)
        toggleSaveButton()

    }
    
    func textViewShouldBeginEditing(textView: UITextView!) -> Bool {
        println("textViewShouldBeginEditing")
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView!) {
        println("textViewDidBeginEditing")
        if (content.text.isEmpty) {
            setupLabelDescription()
            content.selectedRange = NSMakeRange(0, 0)
        }
    }
    
    func textViewShouldEndEditing(textView: UITextView!) -> Bool {
        println("textViewShouldEndEditing")
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView!) {
        println("textViewDidEndEditing")
    }
    
    
    
    
    // ===========================================
    // MARK: View methods
    // ===========================================
    
    func toggleSaveButton() {
        if(!content.text.isEmpty) {
            saveButton.enabled = true;
        } else {
            saveButton.enabled = false
        }
    }
    
    func toggleLabel() {
        if(!content.text.isEmpty) {
            saveButton.enabled = true;
        } else {
            saveButton.enabled = false
        }
    }
    
    func setupCharacterCountLabel() {
        
        var bundle = NSBundle.mainBundle()
        charCountView = (bundle.loadNibNamed("CharacterCountView", owner: self, options: nil)[0] as CharacterCountView)
        
        self.content.inputAccessoryView = charCountView

    }

}
