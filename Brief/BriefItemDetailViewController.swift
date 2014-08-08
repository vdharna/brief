//
//  BriefItemDetailViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 8/1/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class BriefItemDetailViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var table: UITableView!

    var toolbar: UIToolbar!
    var inputAccessoryToolbar: UIToolbar!
    
    var textView: UITextView!
    var inputAccessoryTextView: UITextView!
    
    let cellName = "BriefItemCommentTableViewCell"
    let offScreenCell: BriefItemCommentTableViewCell?
    
    var item: PPPItem?
    
    // MARK: --------------------------------
    // MARK: Init  Methods
    // MARK: --------------------------------
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    // MARK: --------------------------------
    // MARK: Lifecycle  Methods
    // MARK: --------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Comments"
        
        setupTableView()
        setupTextViews()
        setupInputAccessoryToolbar()
        setupDockedToolbar()
        
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
    
    // MARK: --------------------------------
    // MARK: View setup Methods
    // MARK: --------------------------------
    
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
    
    func setupTableView() {
        
        // load the custom cell via NIB
        var nib = UINib(nibName: cellName, bundle: nil)
        
        // Register this NIB, which contains the cell
        self.table.registerNib(nib, forCellReuseIdentifier: cellName)
        
        var bundle = NSBundle.mainBundle()
        var headerView = (bundle.loadNibNamed("CommentHeaderView", owner: self, options: nil)[0] as UIView)
        
        self.table.tableHeaderView = headerView
        self.itemLabel.text = self.item!.getContent()
        
    }
    
    // MARK: --------------------------------
    // MARK: UITextView Delegate Methods
    // MARK: --------------------------------
    
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
    
    // MARK: --------------------------------
    // MARK: UITableView Delegate Methods
    // MARK: --------------------------------
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        var cell = self.table.dequeueReusableCellWithIdentifier(cellName, forIndexPath: indexPath) as BriefItemCommentTableViewCell

        
        // set the author picture
        cell.authorImage.image = UIImage(named: "avatar")
        
        // set the author name
        cell.commentAuthor.text = "Dharminder Dharna"
        
        // set the number of days elapsed since posting
        cell.commentTimestamp.text = "🕗 1d"
        
        //set the actual comment content
        cell.commentContent.numberOfLines = 0
        
        cell.commentContent.text = item!.comments[indexPath.row].getContent()

        return cell
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return item!.commentsCount()
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        return heightForText(item!.comments[indexPath.row].getContent())
    }
    
    func heightForText(text: String) -> CGFloat {
        var textView = UITextView(frame: CGRectMake(0, 0, 256, 2000))
        textView.text = text
        textView.font = UIFont(name: "HelveticaNeue-Light ", size: 12)
        textView.sizeToFit()
        return textView.frame.size.height + 35
    }
    
    
    // MARK: --------------------------------
    // MARK: IB Target/Action Methods
    // MARK: --------------------------------
    
    @IBAction func post() {
        // add the comment to the brief item
        var index = self.item!.commentsCount()
        var comment = Comment(content: self.inputAccessoryTextView.text, createdDate: NSDate(), createdBy: user)
        self.item!.addComment(comment)
        
        // add a new cell into the table
        var indexPath = NSIndexPath(forRow: index, inSection: 0)
        self.table.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)

        self.inputAccessoryTextView.text = ""
        self.inputAccessoryTextView.frame.size.height = 30
        self.inputAccessoryTextView.resignFirstResponder()
        
        self.textView.text = "Enter Comment..."
        self.textView.textColor = UIColor.lightGrayColor()
        
    }

}


