//
//  CompletedBriefViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/22/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class CompletedBriefViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet
    weak var table: UITableView!
    
    @IBOutlet
    weak var collectionView: UICollectionView!
    
    let tableViewCellName = "CompletedBriefTableViewCell"
    let collectionViewCellName = "CompletedBriefCollectionViewCell"
    
    private var completedBriefs = user.getCompletedBriefs()
    private var selectedBrief: Brief?
    
    private var selectedIndexPath:NSIndexPath?
        
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
        var nib = UINib(nibName: tableViewCellName, bundle: nil)
        
        // Register this NIB, which contains the cell
        self.table.registerNib(nib, forCellReuseIdentifier: tableViewCellName)
        
        loadInitialBrief()
        
        //setup the tableview
        setupTableView()
        
        // Register this NIB, which contains the cell
        self.collectionView.registerNib(UINib(nibName: collectionViewCellName, bundle: nil), forCellWithReuseIdentifier: collectionViewCellName)
        
        var cvfl = UICollectionViewFlowLayout()
        cvfl.scrollDirection = UICollectionViewScrollDirection.Horizontal
        cvfl.minimumInteritemSpacing = 0
        cvfl.minimumLineSpacing = 1
        
        self.collectionView.setCollectionViewLayout(cvfl, animated: true)
        
    }

    override func viewWillAppear(animated: Bool) {
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Completed Briefs"
        self.table.reloadData()

        loadBrief()
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
        
        // add refresh control
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("refresh:"), forControlEvents: UIControlEvents.ValueChanged)
        self.table.addSubview(refreshControl)
    }
    
    // ============================================
    // MARK: UITableViewDataSource implementation
    // ============================================
    
    // Asks the data source for a cell to insert in a particular location of the table view. (required)
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        // Get a new or recycled cell
        let cell = self.table.dequeueReusableCellWithIdentifier(tableViewCellName, forIndexPath: indexPath) as CompletedBriefTableViewCell
        var item: PPPItem = getPPPItem(indexPath)
        
        cell.cellLabel.text = item.getContent()
        cell.tag = item.getId()
        
        // show flag status
        if (item.isFlagged()) {
            
            var flagLabel = UILabel(frame: CGRectMake(0, 0, 20, 20))
            flagLabel.tag = 1
            flagLabel.text = "⚑"
            flagLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            flagLabel.textColor = UIColor.grayColor()
            
            // unset all images that CAN render in view 1 so you don't have many instances layered on each other
            cell.view1.viewWithTag(1)?.removeFromSuperview()
            cell.view1.viewWithTag(2)?.removeFromSuperview()
            cell.view1.viewWithTag(3)?.removeFromSuperview()
            
            cell.view1.addSubview(flagLabel)
            
        } else {
            
            cell.view1.viewWithTag(1)?.removeFromSuperview() // unset the flag if it exists
            cell.view1.viewWithTag(2)?.removeFromSuperview() // remove the notification icon
            cell.view1.viewWithTag(3)?.removeFromSuperview() // remove the comment icon
        }
        
        if (user.containsNotification(item.getId())) {
            var notificationLabel = UILabel(frame: CGRectMake(0, 0, 20, 20))
            notificationLabel.tag = 2
            notificationLabel.text = "⌚︎"
            notificationLabel.font = UIFont(name: "HelveticaNeue-Light", size: 17)
            notificationLabel.textColor = UIColor.grayColor()
            
            if (cell.view1.viewWithTag(1) == nil) { //no flag icon is set
                
                // unset all images that CAN render in view 2 so you don't have many instances layered on each other
                cell.view2.viewWithTag(2)?.removeFromSuperview() // remove the notification icon
                cell.view2.viewWithTag(3)?.removeFromSuperview() // remove the comment icon
                
                cell.view1.addSubview(notificationLabel)
                
            } else {
                
                // unset all images that CAN render in view 2 so you don't have many instances layered on each other
                cell.view2.viewWithTag(2)?.removeFromSuperview() // remove the notification icon
                cell.view2.viewWithTag(3)?.removeFromSuperview() // remove the comment icon
            
                cell.view2.addSubview(notificationLabel) // add the notification icon
            }
            
        } else {
            
            cell.view2.viewWithTag(2)?.removeFromSuperview() // remove if it's there already
            cell.view2.viewWithTag(3)?.removeFromSuperview() // remove the comment icon
            
        }
        
        // show comment(s) if any are present
        cell.view1.viewWithTag(3)?.removeFromSuperview() // remove the comment icon
        cell.view2.viewWithTag(3)?.removeFromSuperview() // remove the comment icon
        cell.view3.viewWithTag(3)?.removeFromSuperview() // remove the comment icon
        
        if (item.commentsCount() > 0) {
            //create the uiimage and the count label
            var commentLabel = UILabel(frame: CGRectMake(0, 0, 20, 20))
            commentLabel.text = "\u{1F4AC}"
            commentLabel.font = UIFont(name: "HelveticaNeue-Light", size: 8)
            commentLabel.textColor = UIColor.grayColor()
            commentLabel.tag = 3
            
            if (cell.view1.viewWithTag(1) == nil
                && cell.view1.viewWithTag(2) == nil) { //no flag or notify icon is set
                
                    cell.view1.addSubview(commentLabel)
                    
            }  else if (cell.view1.viewWithTag(1) != nil &&
                cell.view2.viewWithTag(2) != nil) {
                    
                    cell.view3.addSubview(commentLabel)
            
            } else if (cell.view1.viewWithTag(1) != nil &&
                cell.view1.viewWithTag(2) == nil) {

                    cell.view2.addSubview(commentLabel)
                
            } else if (cell.view1.viewWithTag(1) == nil &&
                cell.view1.viewWithTag(2) != nil) {
                    
                    cell.view2.addSubview(commentLabel)
                
            } else {
                
                cell.view3.addSubview(commentLabel)
            
            }

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
        case 0: return selectedBrief!.progress.count
        case 1: return selectedBrief!.plans.count
        case 2: return selectedBrief!.problems.count
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

        var item: PPPItem = self.getPPPItem(indexPath)
        var flagActionTitle = " Flag "
        // create flag title
        if (item.isFlagged()) {
            flagActionTitle = "Unflag"
        }
       
        var flagRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: flagActionTitle, handler:{action, indexpath in
                
            // update the model to reflect the action
            item.flag(!item.isFlagged()) //set the opposite
            self.table.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)
        });
        flagRowAction.backgroundColor = UIColor.orangeColor()
        
        // notify action
        var notifyRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Notify", handler:{action, indexpath in
            
            var itemId = item.getId()
            
            var alertTitle = "Receive notifications when anyone replies to this thread"
            var notifyTitle = "Notify Me"
            if (user.containsNotification(itemId)) {
                alertTitle = "Stop receiving notifications on this thread"
                notifyTitle = "Stop Notifying"
            }
            
            var alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            var cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
                (alertAction: UIAlertAction!) in
                self.table.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)
            })
            
            var notifyAction = UIAlertAction(title: notifyTitle, style: .Default, handler: {
                (alertAction: UIAlertAction!) in
                if (user.containsNotification(itemId)){
                    user.removeNotification(itemId)
                } else {
                    user.addNotification(itemId)
                }
                
                self.table.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)
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
        var item = selectedBrief!.findItemById(cell.tag)
        briefItemDetailVC.item = item
        self.navigationController.pushViewController(briefItemDetailVC, animated: true)
    }

    // MARK: --------------------------------
    // MARK: Utility Methods
    // MARK: --------------------------------
    func loadBrief() {
        // pull the correct Brief based on some parameter
        if (selectedIndexPath != nil) {
            
            var id = self.collectionView.cellForItemAtIndexPath(selectedIndexPath).tag
            self.selectedBrief = user.findBriefById(id)
            
        }
    }
    
    func loadInitialBrief() {
        
        self.selectedBrief = user.getMostRecentBrief()
        
    }
    
    private func getPPPItem(indexPath: NSIndexPath) -> PPPItem {
        
        switch(indexPath.section) {
            
        case 0:
            return selectedBrief!.progress[indexPath.row]
            
        case 1:
            return selectedBrief!.plans[indexPath.row]
            
        case 2:
            return selectedBrief!.problems[indexPath.row]
            
        default:
            return PPPItem(content: "")
            
        }
        
    }
    
    // MARK: --------------------------------
    // MARK: CollectionView Delegate Methods
    // MARK: --------------------------------
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        
        return 1
    
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        
        return self.completedBriefs.count
        
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        
        var cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(collectionViewCellName, forIndexPath: indexPath) as CompletedBriefCollectionViewCell
        
        var brief = user.getCompletedBriefs()[indexPath.row]
        cell.tag = brief.getId()
                
        var df = NSDateFormatter()
        
        df.dateFormat = "dd"
        var myDayString = df.stringFromDate(brief.submittedDate)
        
        df.dateFormat = "MMMM"
        var myMonthString = df.stringFromDate(brief.submittedDate)
        
        df.dateFormat = "yy"
        var myYearString = df.stringFromDate(brief.submittedDate)
        
        cell.monthLabel.text = "\(myMonthString)"
        cell.dateLabel.text = "\(myDayString)"
        
        if (self.selectedIndexPath? != nil && self.selectedIndexPath!.isEqual(indexPath)) {
            
            cell.applySelectedColorScheme()


        } else {
            
            cell.applyUnselectedColorScheme()


        }

        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        
        if (self.selectedIndexPath != nil) {
            // deselect previously selected cell
            var cell = self.collectionView.cellForItemAtIndexPath(self.selectedIndexPath)
            if (cell != nil) {
                
                var c = cell as CompletedBriefCollectionViewCell
                c.applyUnselectedColorScheme()

            }
        } else {
            // remove the color from the first cell since this is the first time it's rendering
            var cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0) )
            
            if (cell != nil) {
                var c = cell as CompletedBriefCollectionViewCell
                
                c.applyUnselectedColorScheme()

            }
        }
        
        var cell = self.collectionView.cellForItemAtIndexPath(indexPath) as CompletedBriefCollectionViewCell
        if (cell != nil) {
            
            cell.applySelectedColorScheme()

        }
        
        // Remember selection:
        self.selectedIndexPath = indexPath
        
        self.selectedBrief = user.findBriefById(cell.tag)
        self.table.reloadData()
        
    }
    
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        return CGSizeMake(56, 39)
    }
    
    // MARK: --------------------------------
    // MARK: Action Methods
    // MARK: --------------------------------
    
    func refresh(refreshControl:UIRefreshControl) {
        self.table.reloadData()
        refreshControl.endRefreshing()
    }
    
}
