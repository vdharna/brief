//
//  AddBriefViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/10/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class AddPPPViewController: UIViewController {

    @IBOutlet
    var content: UITextView!
    
    @IBOutlet
    var itemDescription: UILabel!
    
    var saveButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    
    var charCountView: CharacterCountView!
    var selectedSegment: Int?
    var selectedPPPElement = -1 //default to indicate nothing is transitioned
    var snapshot:String?
    
    var cloudManager = BriefCloudManager()
    
    let progressDescription = "List an accomplishment, finished item or task for the current reporting period"
    let planDescription = "List a goal or objective for the next reporting period"
    let problemDescription = "List an item you can't finish and need escalation or help from someone else"
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // ==========================================
    // MARK: lifecycle methods
    // ==========================================
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        itemDescription.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        itemDescription.numberOfLines = 0
        itemDescription.sizeToFit()
        
        //configure the character count view
        setupCharacterCountLabel()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //setup the content
        configureContent()

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
    
    func configureContent() {
        // Do any additional setup after loading the view.
        content.delegate = self;
        content.returnKeyType = .Default
        content.keyboardAppearance = UIKeyboardAppearance.Dark
        content.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        content.becomeFirstResponder()
        content.keyboardType = .ASCIICapable
    }
    
    func configureNavigationBar() {
        
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
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
            
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
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
                println("") //need a line of code to make this work for some reason
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
        var draftBrief = user.getDraftBrief()
        
        switch (selectedSegment!) {
            
        case 0:
        
            if (editMode) {
                var progress = user.getDraftBrief().progress[selectedPPPElement] as Progress
                // update the progress item
                progress.content = self.content.text
                draftBrief.updateProgress(self.selectedPPPElement, p: progress)
                
                self.cloudManager.fetchRecordWithID(progress.id, completionClosure: { record in
                    // update the record for CloudKit
                    record.setObject(progress.content, forKey: "content")
                    self.cloudManager.saveRecord(record, completionClosure: { success in
                    })
                })
                
                
            } else {
                
                //create progress item in iCloud
                var progress = Progress(content: content.text)
                self.cloudManager.addProgressRecord(progress, completionClosure: { record in
                })
                
                draftBrief.addProgress(progress)
                
            }
            
        case 1:
            
            if (editMode) {
                
                var plan = user.getDraftBrief().plans[selectedPPPElement] as Plan
                // update the plan item
                plan.content = self.content.text
                draftBrief.updatePlan(self.selectedPPPElement, p: plan)
                
                self.cloudManager.fetchRecordWithID(plan.id, completionClosure: { record in
                    // update the record for CloudKit
                    record.setObject(plan.content, forKey: "content")
                    self.cloudManager.saveRecord(record, completionClosure: { success in
                    })
                })
                
            } else {
                
                //create plan item in iCloud
                var plan = Plan(content: content.text)
                self.cloudManager.addPlanRecord(plan, completionClosure: { record in
                })
                
                draftBrief.addPlan(plan)
                
            }
            
        case 2:
            
            if (editMode) {
                var problem = user.getDraftBrief().problems[selectedPPPElement] as Problem
                // update the problem item
                problem.content = self.content.text
                draftBrief.updateProblem(self.selectedPPPElement, p: problem)
                
                self.cloudManager.fetchRecordWithID(problem.id, completionClosure: { record in
                    // update the record for CloudKit
                    record.setObject(problem.content, forKey: "content")
                    self.cloudManager.saveRecord(record, completionClosure: { success in
                    })
                })
                
                
            } else {
                
                //create problem item in iCloud
                var problem = Problem(content: content.text)
                self.cloudManager.addProblemRecord(problem, completionClosure: { record in
                })
                
                draftBrief.addProblem(problem)
                
            }
            
        default:
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})

        }
                
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})

    }
    
    // ===========================================
    // MARK: Helper methods
    // ===========================================
    
    
    func setContentForEdit() {
        if (selectedPPPElement > -1) { //something was passed for edit
            switch (selectedSegment!) {
                
            case 0:
                content.text = user.getDraftBrief().progress[selectedPPPElement].getContent()

            case 1:
                content.text = user.getDraftBrief().plans[selectedPPPElement].getContent()
                
            case 2:
                content.text = user.getDraftBrief().problems[selectedPPPElement].getContent()
                
            default:
                content.text = ""
            }
        }
    }
    
    
    func configureLabelDescription() {
        
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

// ===========================================
// MARK: TextView Delegate methods
// ===========================================

extension AddPPPViewController: UITextViewDelegate {
    
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
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView!) {
        if (content.text.isEmpty) {
            configureLabelDescription()
            content.selectedRange = NSMakeRange(0, 0)
        }
    }
    
    func textViewShouldEndEditing(textView: UITextView!) -> Bool {
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView!) {
    }
    
}
