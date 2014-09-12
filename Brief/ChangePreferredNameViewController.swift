//
//  ChangePreferredNameViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 9/11/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class ChangePreferredNameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var table: UITableView!
    
    var textField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureNavigationBar()
        
        self.table.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func configureNavigationBar() {
        
        var saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: Selector("save"))
        var cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("dismissModal"))
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.title = "Compose"
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func dismissModal() {
        self.textField.resignFirstResponder()
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            
    }
    
    func save() {
        self.textField.resignFirstResponder()
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: --------------------------------
    // MARK: UITableViewDatasource methods
    // MARK: --------------------------------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.table.dequeueReusableCellWithIdentifier("UITableViewCell") as UITableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        var text = "Name"
        cell.textLabel?.text = text
        
        textField = UITextField(frame: CGRectMake(100, 0, cell.frame.width - 100, cell.frame.height))
        textField.adjustsFontSizeToFitWidth = true
        textField.textColor = UIColor.blackColor()
        textField.returnKeyType = UIReturnKeyType.Done
        textField.backgroundColor = UIColor.whiteColor()
        textField.autocorrectionType = UITextAutocorrectionType.No
        textField.textAlignment = NSTextAlignment.Left
        textField.enabled = true
        textField.becomeFirstResponder()
        textField.delegate = self
        
        if let preferredName = user.preferredName {
            if (!preferredName.isEmpty) {
                self.textField.text = preferredName
            } else {
                textField.placeholder = "Enter Name Here"
            }
        }
        
        
        cell.contentView.addSubview(textField)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    // MARK: --------------------------------
    // MARK: UITextFieldDelegate methods
    // MARK: --------------------------------
    
    func textFieldDidEndEditing(textField: UITextField) {
        user.updatePreferredName(textField.text)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
