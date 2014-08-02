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

        self.inputAccessoryToolbar.removeFromSuperview() //needs to be assigned
        textField.inputAccessoryView = inputAccessoryToolbar
                
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

}
