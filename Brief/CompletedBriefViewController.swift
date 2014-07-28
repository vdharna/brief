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
    
    var completedBriefs = user.getCompletedBriefs()
    private var completedBrief: Brief?
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
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
        var item: PPPItem?
        
        // populate the table with a brief
        switch(indexPath.section) {
        case 0:
            item = completedBrief!.progress[indexPath.row]
            cell.cellLabel.text = item!.getContent()
            cell.tag = item!.getId()
            
        case 1:
            item = completedBrief!.plans[indexPath.row]
            cell.cellLabel.text = item!.getContent()
            cell.tag = item!.getId()
        
        case 2:
            item = completedBrief!.problems[indexPath.row]
            cell.cellLabel.text = item!.getContent()
            cell.tag = item!.getId()
        
        default:
            cell.cellLabel.text = "No Text"
            cell.tag = 0
            
        }
        
        // Stops a string reference cycle from happening
        weak var weakCell = cell
        
        cell.flagActionClosure = {
            let strongCell = weakCell
            
            var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil )
            actionSheet.tag = 0 // represents a flag action
            
            if (item!.isFlagged()) {
                actionSheet.addButtonWithTitle("Unflag")
            } else {
                actionSheet.addButtonWithTitle("Flag")
            }
            
            actionSheet.showInView(UIApplication.sharedApplication().keyWindow)
            
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
            println("Cancel called")
            
        case 1: //flag
            println("Flag called")
            
        default:
            break
        }
        
    }
    
    
    // ============================================
    // MARK: Actions
    // ============================================
    
    func flag(sender: AnyObject) {
        println("flag")
        println("\(sender.tag)")
    }
    
    func comment(sender: AnyObject) {
        println("comment")
        println("\(sender.tag)")
    }
    
    func share(sender: AnyObject) {
        println("share")
        println("\(sender.tag)")
    }
    
    // ============================================
    // MARK: Utility Methods
    // ============================================
    func loadBrief() {
        // pull the correct Brief based on some parameter
        let randomIndex = Int(arc4random_uniform(UInt32(completedBriefs.count)))
        self.completedBrief = completedBriefs[randomIndex]
    }

}
