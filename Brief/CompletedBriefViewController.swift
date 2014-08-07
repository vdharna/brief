//
//  CompletedBriefViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/22/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class CompletedBriefViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var table: UITableView!
    
    let cellName = "CompletedBriefTableViewCell"
    
    private var completedBriefs = user.getCompletedBriefs()
    private var completedBrief: Brief?
        
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    // ============================================
    // MARK: UIViewController Lifecycle Methods
    // ============================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load the custom cell via NIB
        var nib = UINib(nibName: cellName, bundle: nil)
        
        // Register this NIB, which contains the cell
        self.table.registerNib(nib, forCellReuseIdentifier: cellName)
        
        loadBrief()
        
        //setup the tableview
        setupTableView()
        
    }

    override func viewWillAppear(animated: Bool) {
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Completed Briefs"
    }
    
    override func viewWillDisappear(animated: Bool) {
        // Do any additional setup after loading the view.
        self.navigationItem.title = ""
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
    
    // MARK: --------------------------------
    // MARK: TableView Delegate Methods
    // MARK: --------------------------------
    
    // Asks the delegate for the height to use for a row in a specified location.
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        return 90
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
    
    func tableView(tableView: UITableView!, editActionsForRowAtIndexPath indexPath: NSIndexPath!) -> [AnyObject]! {

        var flagRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Flag", handler:{action, indexpath in
            
            println("FLAG•ACTION");
            
            var item: PPPItem = self.getPPPItem(indexPath)
            
            var alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            // create flag action button
            var flagActionTitle = "Flag"
            if (item.isFlagged()) {
                flagActionTitle = "Unflag"
            }
            
            var flagAction = UIAlertAction(title: flagActionTitle, style: .Default, handler: {
                (alertAction: UIAlertAction!) in
                
                // update the model to reflect the action
                item.flag(!item.isFlagged()) //set the opposite
                self.table.reloadData()
            })
            
            var cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
                (alertAction: UIAlertAction!) in
                
                self.table.reloadData()
            })
            
            alert.addAction(flagAction)
            alert.addAction(cancelAction)
            
            self.presentViewController(alert, animated: true, completion: {})
        });
        flagRowAction.backgroundColor = UIColor.orangeColor()
        
        // notify action
        var notifyRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Notify", handler:{action, indexpath in
            println("NOTIFY•ACTION");
            
            var alert = UIAlertController(title: "Receive notifications when anyone replies to his thread", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            
            var cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
                (alertAction: UIAlertAction!) in
                self.table.reloadData()
            })
            
            var notifyAction = UIAlertAction(title: "Notify Me", style: .Default, handler: {
                (alertAction: UIAlertAction!) in
                self.table.reloadData()
            })
            
            alert.addAction(cancelAction)
            alert.addAction(notifyAction)
            
            self.presentViewController(alert, animated: true, completion: {})
        });
        notifyRowAction.backgroundColor = UIColor.blueColor();
        
        // share action
        var shareRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Share", handler:{action, indexpath in
            println("SHARE•ACTION");
            var alert = UIAlertView(title: "Action", message: "Share Button Clicked", delegate: nil, cancelButtonTitle: "Cancel")
            alert.show()
        });
        shareRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        return [shareRowAction, notifyRowAction, flagRowAction];
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var briefItemDetailVC = BriefItemDetailViewController(nibName: "BriefItemDetailViewController", bundle: NSBundle.mainBundle())
        
        //get reference to the cell
        var cell = self.table.cellForRowAtIndexPath(indexPath)
        briefItemDetailVC.itemLabel.text = completedBrief!.findItemById(cell.tag).getContent()
        briefItemDetailVC.brief = completedBrief
        self.navigationController.pushViewController(briefItemDetailVC, animated: true)
    }
    
    

    
    
    // MARK: --------------------------------
    // MARK: Utility Methods
    // MARK: --------------------------------
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
    
}
