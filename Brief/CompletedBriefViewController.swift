//
//  CompletedBriefViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/22/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class CompletedBriefViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var table: UITableView!
    
    let cellName = "CompletedBriefTableViewCell"
    
    private var completedBriefs = user.getCompletedBriefs()
    private var completedBrief: Brief?
    
    private var flagIsOn = false
    
    private var notificationDelegate: NotificationDelegate?
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // ============================================
    // MARK: UIViewController Lifecycle Methods
    // ============================================
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Completed Briefs"
        
        // load the custom cell via NIB
        var nib = UINib(nibName: cellName, bundle: nil)
        
        // Register this NIB, which contains the cell
        self.table.registerNib(nib, forCellReuseIdentifier: cellName)
        
        loadBrief()
        
        //setup the tableview
        setupTableView()
        

        
    }

    override func viewWillAppear(animated: Bool) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTableView() {
        var footer = UIView(frame: CGRectMake(0, 0, self.table.frame.width, 25))
        footer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.92)
        self.table.tableFooterView = footer
    }
    
    // ============================================
    // MARK: UITableViewDataSource implementation
    // ============================================
    
    // Asks the data source for a cell to insert in a particular location of the table view. (required)
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        // Get a new or recycled cell
        let cell = self.table.dequeueReusableCellWithIdentifier(cellName, forIndexPath: indexPath) as CompletedBriefTableViewCell
        var item: PPPItem = getPPPItem(indexPath)
        
        cell.cellLabel.text = item.getContent()
        cell.tag = item.getId()
        
        // set flag as on or off
        if (item.isFlagged()) {
            cell.flagImage.image = UIImage(named: "flag_icon_selected.png")
        } else {
            cell.flagImage.image = UIImage(named: "flag_icon.png")
        }
        
        //load the comments label with the appropriate number of comments
        cell.commentsLabel.text = "0 Comments"
        
        // Stops a string reference cycle from happening
        weak var weakCell = cell
        
        cell.flagActionClosure = {
            let strongCell = weakCell
            
            var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil )
            actionSheet.tag = item.getId() // represents a flag action
            
            if (item.isFlagged()) {
                actionSheet.addButtonWithTitle("Unflag")
            } else {
                actionSheet.addButtonWithTitle("Flag")
            }
            
            actionSheet.addButtonWithTitle("Notify Me...")
            actionSheet.showInView(self.view)
            
        }
        
        cell.commentActionClosure = {
            
            var alert = UIAlertView(title: "Action", message: "Comment Button Clicked", delegate: nil, cancelButtonTitle: "Cancel")
            alert.show()
        }
        
        cell.shareActionClosure = {
            
            var alert = UIAlertView(title: "Action", message: "Share Button Clicked", delegate: nil, cancelButtonTitle: "Cancel")
            alert.show()
        }
  
        return cell
    }
    
    // Asks the data source to return the number of sections in the table view.
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        
        return 3
        
    }

    // Tells the data source to return the number of rows in a given section of a table view. (required)
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        
        switch(section) {
        case 0: return completedBrief!.progress.count
        case 1: return completedBrief!.plans.count
        case 2: return completedBrief!.problems.count
        default: return 0
        }
        
    }

    // Asks the data source for the title of the header of the specified section of the table view.
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        
        switch (section) {
        case 0: return "Progress"
        case 1: return "Plans"
        case 2: return "Problems"
        default: return ""
        }
    }
    
    // Asks the data source to verify that the given row is editable.
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return false
    }
    
    // Asks the data source whether a given row can be moved to another location in the table view.
    func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
       return false
    }
    
    // ============================================
    // MARK: UITableViewDelegate implementation
    // ============================================
    
    // Asks the delegate for the height to use for a row in a specified location.
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        return 100
    }
    
    func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 25
    }
    
    func tableView(tableView: UITableView!, willDisplayHeaderView view: UIView!, forSection section: Int) {
        
        //background color
        view.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.92)
        
        //text color
        var header = view as UITableViewHeaderFooterView
        header.textLabel.textColor = UIColor.whiteColor()
        
        
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println("\(indexPath)")
    }
    
    // ===========================================
    // MARK: Action Sheet delegation method
    // ===========================================
    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        
        switch(buttonIndex) {
            
        case 0: //cancel
            break
            
        case 1: //flag

            // update the model to reflect the action
            var item = self.completedBrief!.findItemById(actionSheet.tag)
            item.flag(!item.isFlagged()) //set the opposite
            self.table.reloadData()
            
        case 2: // notify me..
            // call a subsequent uiaction sheet for this
            var item = self.completedBrief!.findItemById(actionSheet.tag)
            notificationDelegate = NotificationDelegate(item: item)
            var notifyActionSheet = UIActionSheet(title: "Receive notifications when anyone replies to his thread", delegate: notificationDelegate, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
            notifyActionSheet.addButtonWithTitle("Notify Me")
            notifyActionSheet.showInView(self.view)
            
        default:
            break
        }
        
    }
    
    // ============================================
    // MARK: Utility Methods
    // ============================================
    func loadBrief() {
        // pull the correct Brief based on some parameter
        let randomIndex = Int(arc4random_uniform(UInt32(completedBriefs.count)))
        self.completedBrief = completedBriefs[randomIndex]
    }
    
    private func getPPPItem(indexPath: NSIndexPath) -> PPPItem {
        
        switch(indexPath.section) {
            
        case 0:
            return completedBrief!.progress[indexPath.row]
            
        case 1:
            return completedBrief!.plans[indexPath.row]
            
        case 2:
            return completedBrief!.problems[indexPath.row]
            
        default:
            return PPPItem(content: "")
            
        }
        
    }
    
    // ============================================
    // MARK: Nested Classes for Action Sheets
    // ============================================
    
    class NotificationDelegate: NSObject, UIActionSheetDelegate {
        
        var item:PPPItem?
        
        init(item: PPPItem) {
            self.item = item
        }
        
        func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
            
            switch(buttonIndex) {
                
            case 0: //cancel
                break
                
            case 1:
                var alert = UIAlertView(title: "Action", message: "Call BriefNotificationService for this action", delegate: nil, cancelButtonTitle: "Cancel")
                alert.show()
                
            default:
                break
            }
            
        }
        
    }

}
