//
//  CompletedBriefViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/22/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class MasterBriefViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: --------------------------------
    // MARK: Properties
    // MARK: --------------------------------
    
    @IBOutlet
    weak var table: UITableView!
    
    var cview = UIView(frame: CGRectMake(0, 64, 320, 44))
    var collectionView: UICollectionView!
    
    @IBOutlet
    weak var noBriefLabel: UILabel!
    
    let tableViewCellName = "CompletedBriefTableViewCell"
    let collectionViewCellName = "CompletedBriefCollectionViewCell"
    
    private var completedBriefs = user.getCompletedBriefs()
    private var selectedBrief: Brief?
    
    private var selectedIndexPath:NSIndexPath?
    
    private var cloudManager = BriefCloudManager()
    
    // MARK: --------------------------------
    // MARK: Initializers
    // MARK: --------------------------------
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: --------------------------------
    // MARK: UIViewController Lifecycle
    // MARK: --------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView = UICollectionView(frame: CGRectMake(0, 2, 320, 40), collectionViewLayout: UICollectionViewFlowLayout())
        
        self.cview.backgroundColor = UIColor.whiteColor()
        self.cview.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if (!user.getCompletedBriefs().isEmpty) {
            
            // Do any additional setup after loading the view.
            self.noBriefLabel.hidden = true
            self.table.hidden = false
            self.collectionView.hidden = false
            self.table.hidden = true
            self.collectionView.hidden = true
            
            // start the activity spinner
            var progressView = ProgressView(frame: CGRectMake(0, 0, 300, 300))
            self.view.addSubview(progressView)
            
            self.loadInitialBrief({ completed in
                self.table.reloadData()
                self.table.hidden = false
                self.collectionView.hidden = false
                progressView.removeFromSuperview()

            })
            self.configureTableView()
            self.configureCollectionView()
            
        } else {
            
            self.noBriefLabel.hidden = false
            self.table.hidden = true
            self.collectionView.hidden = true
            
            self.noBriefLabel.text = "There are no completed Briefs to show"
            
        }
        
        var briefs = user.getCompletedBriefs()
        
    }

    override func viewWillAppear(animated: Bool) {
        
        configureNavBar()
        //reload the table to capture any comments that may have been added
        if (!user.getCompletedBriefs().isEmpty) {
            self.table.reloadData()
        }
        
        var briefs = user.getCompletedBriefs()
        //self.table.tableHeaderView = self.cview
        self.view.addSubview(cview)
        self.navigationController.hidesBarsOnSwipe = false
        self.navigationController.hidesBarsOnTap = false

    }
    
    override func viewWillDisappear(animated: Bool) {
        // Do any additional setup after loading the view.
        self.navigationItem.title = ""
        if (self.selectedIndexPath != nil) {
            self.collectionView.scrollToItemAtIndexPath(self.selectedIndexPath, atScrollPosition: UICollectionViewScrollPosition.None, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureNavBar() {
        self.navigationItem.title = "Completed Briefs"
        
    }
    
    func configureTableView() {
        
        // load the custom cell via NIB
        var nib = UINib(nibName: tableViewCellName, bundle: nil)
        
        // Register this NIB, which contains the cell
        self.table.registerNib(nib, forCellReuseIdentifier: tableViewCellName)
        
        // add refresh control
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("refresh:"), forControlEvents: UIControlEvents.ValueChanged)
        self.table.addSubview(refreshControl)
        
        self.table.estimatedRowHeight = 44.0
        self.table.rowHeight = UITableViewAutomaticDimension
        self.table.sectionHeaderHeight = UITableViewAutomaticDimension
    }
    
    func configureCollectionView() {
        
        // load the custom cell via NIB
        var nib = UINib(nibName: collectionViewCellName, bundle: nil)
        
        // Register this NIB, which contains the cell
        self.collectionView.registerNib(UINib(nibName: collectionViewCellName, bundle: nil), forCellWithReuseIdentifier: collectionViewCellName)
        
        var cvfl = UICollectionViewFlowLayout()
        cvfl.scrollDirection = UICollectionViewScrollDirection.Horizontal
        cvfl.minimumInteritemSpacing = 0
        cvfl.minimumLineSpacing = 1
        
        self.collectionView.setCollectionViewLayout(cvfl, animated: true)
    }
    
    // MARK: ------------------------------------
    // MARK: UITableViewDataSource implementation
    // MARK: ------------------------------------
    
    // Asks the data source for a cell to insert in a particular location of the table view. (required)
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        // Get a new or recycled cell
        let cell = self.table.dequeueReusableCellWithIdentifier(tableViewCellName, forIndexPath: indexPath) as CompletedBriefTableViewCell
        var item: PPPItem = getPPPItem(indexPath)
        
        cell.cellLabel.text = item.getContent()
        cell.itemID = item.getId()
        
        
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
            
            var image = UIImageView(frame: CGRectMake(1, 5, 10, 10))
            image.image = UIImage(named: "alarm.png")
            notificationLabel.addSubview(image)

            
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
        
        if (item.hasComments()) {
            //create the uiimage and the count label
            var commentLabel = UILabel(frame: CGRectMake(0, 0, 20, 20))
            var image = UIImageView(frame: CGRectMake(-4, 0, 20, 20))
            image.image = UIImage(named: "speech-bubble-32.png")
            commentLabel.addSubview(image)
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
        
        if (!user.getCompletedBriefs().isEmpty) {
            switch(section) {
            
                case 0: return selectedBrief!.progress.count
                case 1: return selectedBrief!.plans.count
                case 2: return selectedBrief!.problems.count
                default: return 0
            }
        } else {
            
            return 0
        }
    
    }

    
    func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView! {
        
        var string = ""
        
        switch(section) {
            
        case 0: string = "Progress"
            
        case 1: string = "Plans"
            
        case 2: string = "Problems"
            
        default: string = ""
        }
        
        var bundle = NSBundle.mainBundle()
        var headerView = (bundle.loadNibNamed("SectionHeader", owner: self, options: nil)[0] as SectionHeader)
        headerView.label1.text = string
        
        return headerView
    }
    
    func tableView(tableView: UITableView!, willDisplayHeaderView view: UIView!, forSection section: Int) {
    }
    
    func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 24
    }
    
    // MARK: --------------------------------
    // MARK: TableView Delegate Methods
    // MARK: --------------------------------

    
    func tableView(tableView: UITableView!, editActionsForRowAtIndexPath indexPath: NSIndexPath!) -> [AnyObject]! {

        var item: PPPItem = self.getPPPItem(indexPath)
        if (item.id.isEmpty) {
            return []
        }
        var flagActionTitle = " Flag "
        // create flag title
        if (item.isFlagged()) {
            flagActionTitle = "Unflag"
        }
       
        var flagRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: flagActionTitle, handler:{action, indexpath in
                
            // update the model to reflect the action
            item.setFlag(!item.isFlagged()) //set the opposite 
            // update iCloud to reflect this change
            self.cloudManager.fetchRecordWithID(item.id, completionClosure: { record in
                
                record.setObject(item.isFlagged(), forKey:"flag")
                self.cloudManager.saveRecord(record, completionClosure: { completed in
                    //update the view
                    self.table.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)
                })
            })
        });
        flagRowAction.backgroundColor = UIColor.orangeColor()
        
        // notify action
        var notifyRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Notify", handler:{ action, indexpath in
            
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
                    self.table.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)
                } else {
                    user.addNotification(item, completionClosure: { completed in
                        self.table.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)
                    })
                }
                
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
        
        var briefItemDetailVC = DetailBriefItemViewController(nibName: "DetailBriefItemViewController", bundle: NSBundle.mainBundle())
        
        //get reference to the cell
        var cell = self.table.cellForRowAtIndexPath(indexPath) as CompletedBriefTableViewCell
        var item = selectedBrief!.findItemById(cell.itemID)
        briefItemDetailVC.item = item
        self.navigationController.pushViewController(briefItemDetailVC, animated: true)
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
        cell.briefId = brief.getId()
                
        var df = NSDateFormatter()
        
        df.dateFormat = "dd"
        var myDayString = df.stringFromDate(brief.submittedDate!)
        
        df.dateFormat = "MMMM"
        var myMonthString = df.stringFromDate(brief.submittedDate!)
        
        df.dateFormat = "yy"
        var myYearString = df.stringFromDate(brief.submittedDate!)
        
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
        cell.applySelectedColorScheme()

        
        // Remember selection:
        self.selectedIndexPath = indexPath
        
        // start the activity spinner
        var progressView = ProgressView(frame: CGRectMake(0, 0, 300, 300))
        self.view.addSubview(progressView)
        
        user.findBriefById(cell.briefId, completionClosure: { brief in
            self.selectedBrief = brief
            self.table.reloadData()
            progressView.removeFromSuperview()
        })
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        return CGSizeMake(60, 40)
    }

    
    // MARK: --------------------------------
    // MARK: Action Methods
    // MARK: --------------------------------
    
    func refresh(refreshControl:UIRefreshControl) {
        
        user.findBriefById(selectedBrief!.id, completionClosure: { brief in
            self.selectedBrief = brief
            self.table.reloadData()
            refreshControl.endRefreshing()
        })
    }
    
    // MARK: --------------------------------
    // MARK: Utility Methods
    // MARK: --------------------------------
    func loadInitialBrief(completionClosure: ((Bool) -> Void)) {

        self.selectedBrief = user.getMostRecentBrief()
        self.selectedIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        self.collectionView.scrollToItemAtIndexPath(self.selectedIndexPath, atScrollPosition: UICollectionViewScrollPosition.None, animated: true)
        
        self.selectedBrief!.loadPPPItems({ completed in
            
            dispatch_async(dispatch_get_main_queue(), {
                completionClosure(completed)
            })
        })

    
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
    
}
