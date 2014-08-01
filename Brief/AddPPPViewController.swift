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
    var charCountView: CharacterCountView?
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //setup the content
        setupContent()
        //configure the character count view
        setupCharacterCountLabel()
        setContentForEdit()
        self.charCountView!.updateCharacterCount(content.text.utf16Count)
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
    
    func textViewDidChange(textView: UITextView!) {
        
        self.charCountView!.updateCharacterCount(content.text.utf16Count)
        toggleSaveButton()
    }
    
    
    // ===========================================
    // MARK: View methods
    // ===========================================
    func setupCharacterCountLabel() {
        
        var bundle = NSBundle.mainBundle()
        charCountView = (bundle.loadNibNamed("CharacterCountView", owner: self, options: nil)[0] as CharacterCountView)
        
        self.content.inputAccessoryView = charCountView

    }

}
