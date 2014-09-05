//
//  BriefItemDetailViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 8/1/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class DetailBriefItemViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: --------------------------------
    // MARK: Properties
    // MARK: --------------------------------

    @IBOutlet
    weak var itemLabel: UILabel!
    
    @IBOutlet
    weak var table: UITableView!
    
    @IBOutlet
    weak var noCommentLabel: UILabel!

    var toolbar: UIToolbar!
    var inputAccessoryToolbar: UIToolbar!
    
    var textView: UITextView!
    var inputAccessoryTextView: UITextView!
    
    let cellName = "BriefItemCommentTableViewCell"
    let offScreenCell: BriefItemCommentTableViewCell?
    
    var item: PPPItem!
    
    var cloudManager = BriefCloudManager()
    
    // MARK: --------------------------------
    // MARK: Init  Methods
    // MARK: --------------------------------
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: --------------------------------
    // MARK: Lifecycle  Methods
    // MARK: --------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Comments"
        self.navigationController.hidesBarsOnSwipe = true
        self.navigationController.hidesBarsOnTap = true
        
        self.configureTableView()
        self.configureTextViews()
        self.configureInputAccessoryToolbar()
        self.configureDockedToolbar()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // start the activity spinner
        var progressView = ProgressView(frame: CGRectMake(0, 0, 300, 300))
        progressView.captionText = "Loading Comments..."
        self.view.addSubview(progressView)
        item.loadCommentsFromiCloud({ completed in
            self.table.reloadData()
            progressView.removeFromSuperview()
            self.determineNoCommentLabelVisibility()

        })        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: --------------------------------
    // MARK: View setup Methods
    // MARK: --------------------------------
    
    func configureTextViews() {
        
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
    
    func configureInputAccessoryToolbar() {
        
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
        postButton.enabled = false

        postButton.tintColor = UIColor.whiteColor()

        inputAccessoryToolbar.setItems([cameraButton, textViewButton, postButton], animated: true)
        inputAccessoryToolbar.sizeToFit()
        
        
    }
    
    func configureDockedToolbar() {
        
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
    
    func configureTableView() {
        
        // load the custom cell via NIB
        var nib = UINib(nibName: cellName, bundle: NSBundle.mainBundle())
        
        // Register this NIB, which contains the cell
        self.table.registerNib(nib, forCellReuseIdentifier: cellName)
        
        var bundle = NSBundle.mainBundle()
        var headerView = (bundle.loadNibNamed("CommentHeaderView", owner: self, options: nil)[0] as UIView)
        
        headerView.sizeToFit()
        
        self.table.tableHeaderView = headerView
        self.table.estimatedRowHeight = 44.0
        self.table.rowHeight = UITableViewAutomaticDimension
        self.itemLabel.text = self.item.getContent()
        
    }
    
    // MARK: --------------------------------
    // MARK: UITextView Delegate Methods
    // MARK: --------------------------------
    
    func textViewDidBeginEditing(textView: UITextView!) {
        
        if (table.numberOfRowsInSection(0) > 0) {
            scrollToLastVisibleRow()
        }
        
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
        
        var button = self.inputAccessoryToolbar.items[2] as UIBarButtonItem
        if (!textView.text.isEmpty) {
            button.enabled = true
        } else {
            button.enabled = false

        }
        
    }
    
    // MARK: --------------------------------
    // MARK: UITableView Delegate Methods
    // MARK: --------------------------------
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        var cell = self.table.dequeueReusableCellWithIdentifier(cellName, forIndexPath: indexPath) as BriefItemCommentTableViewCell

        
        // set the author picture
        cell.authorImage.image = UIImage(named: "avatar.png")
        
        // set the author name
        cell.commentAuthor.text = item.comments[indexPath.row].createdBy
        
        // set the number of days elapsed since posting
      //  cell.commentTimestamp.text = item.comments[indexPath.row].getElapsedTime()

        //set the actual comment content
        cell.commentContent.numberOfLines = 0
        
        cell.commentContent.text = item.comments[indexPath.row].content

        return cell
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return item.commentsCount()
    }
    
    
    // MARK: --------------------------------
    // MARK: IB Target/Action Methods
    // MARK: --------------------------------
    
    @IBAction func post() {
        
        if (!self.inputAccessoryTextView.text.isEmpty) {
            // add the comment to the brief item
            var index = self.item.commentsCount()
            var indexPath = NSIndexPath(forRow: index, inSection: 0)
            
            // create the comment
            var comment = Comment(content: self.inputAccessoryTextView.text)
            comment.createdBy = user.userInfo!.firstName
            comment.createdDate = NSDate()
            
            // add locally
            self.item.addComment(comment)
            
            self.determineNoCommentLabelVisibility()
            
            // add a new cell into the table
            self.table.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            // reset the text fields and clean-up for the next entry
            self.inputAccessoryTextView.text = ""
            var button = self.inputAccessoryToolbar.items[2] as UIBarButtonItem
            button.enabled = false
            self.inputAccessoryTextView.frame.size.height = 30
            self.inputAccessoryTextView.resignFirstResponder()
            
            self.textView.text = "Enter Comment..."
            self.textView.textColor = UIColor.lightGrayColor()
            
            self.scrollToBottom()
            
            // add comment to iCloud
            cloudManager.addCommentRecord(comment, item: item, completionClosure: { record in

            })

        }
        
    }
    
    
    func scrollToBottom() {

        self.table.scrollToRowAtIndexPath(NSIndexPath(forRow: self.item.commentsCount() - 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)

    }
    
    func scrollToLastVisibleRow() {
        
        var keyboardHeight = 300.0
        self.table.setContentOffset(CGPointMake(0, self.table.contentSize.height - 230), animated: true)
    }
    
    func determineNoCommentLabelVisibility() {
        
        // if the comment count is 0 then hide the table and show the label
        if (self.item?.commentsCount() == 0) {
            
            self.noCommentLabel.hidden = false
            self.table.separatorStyle = UITableViewCellSeparatorStyle.None
            
        } else {
            
            self.noCommentLabel.hidden = true
            self.table.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            
        }
    }


}


