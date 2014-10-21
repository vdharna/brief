//
//  SecondViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/8/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit
import CloudKit

let characterLimit = 140

class ComposeViewController: UIViewController {
   
    // MARK: --------------------------------
    // MARK: Properties
    // MARK: --------------------------------
    
    @IBOutlet
    weak var toolbar: UIToolbar!
    
    @IBOutlet
    weak var deleteButton: UIBarButtonItem!
    
    @IBOutlet
    weak var actionButton: UIBarButtonItem!
    
    @IBOutlet
    weak var table: UITableView!
    
    @IBOutlet
    weak var descriptionLabel: UILabel!
    
    @IBOutlet
    weak var noItemLabel: UILabel!
    
    let progressDescription = "List your accomplishments, finished items and closed tasks for the current reporting period"
    let planDescription = "List your goals and objectives for the next reporting period"
    let problemDescription = "List items you can't finish and need escalation or help from someone else."
    
    let segmentedControl = UISegmentedControl(items: ["Progress", "Plans", "Problems"])
    
    let cellName = "ComposeItemTableViewCell"
    let redCellImage = UIImage(named: "compose-table-cell-red.png")
    let greenCellImage = UIImage(named: "compose-table-cell-green.png")
    
    let tableCellHeight:CGFloat = 130
    
    var selectedSegment = 0 //remember which segment was selected
    
    var snapshot: UIView?        ///< A snapshot of the row user is moving.
    var sourceIndexPath:NSIndexPath? ///< Initial index path, where gesture begins.
    
    var cloudManager = BriefCloudManager()
    
    let overlayTransitioningDelegate = OverlayTransitioningDelegate()

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: --------------------------------
    // MARK: Lifecycle Methods
    // MARK: --------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSegmentView()
        configureDescriptionLabel()
        configureTableView()
        configureToolbarView()
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = false
        self.segmentedControl.selectedSegmentIndex = selectedSegment //sets to last selected segment
        self.refreshToolbarItems()
        self.table.reloadData()
        self.determineNoPPPItemLabelVisibility()
        
    }
    
    override func viewWillDisappear(animated: Bool)  {
        
    }
    
    // MARK: --------------------------------
    // MARK: View Configuration Methods
    // MARK: --------------------------------
    
    func configureSegmentView() {
        
        //set the segment in the navigation bar
        segmentedControl.addTarget(self, action: Selector("segmentChanged"), forControlEvents: .ValueChanged)
        segmentedControl.selectedSegmentIndex = selectedSegment //defaults to the first segment
        segmentedControl.sizeToFit()
        self.navigationItem.titleView = segmentedControl
       
        //add the + button
        var addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("add"))
        self.navigationItem.rightBarButtonItem = addButton;
    }
    
    func configureDescriptionLabel() {

        var formattedText = formatDescLabelText(progressDescription)
        descriptionLabel.attributedText = formattedText
        
        //use this to align the text to the top
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.sizeToFit()
    }
    
    func configureTableView() {

        table.separatorStyle = UITableViewCellSeparatorStyle.None
        table.delegate = self
        table.dataSource = self
        
        //for reusable cells
        // load the custom cell via NIB
        var nib = UINib(nibName: cellName, bundle: NSBundle.mainBundle())
        
        // Register this NIB, which contains the cell
        table.registerNib(nib, forCellReuseIdentifier: cellName)
        
        table.allowsMultipleSelectionDuringEditing = false
        
        //add long tap gesture recognizer
        var longPress = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognized:")
        table.addGestureRecognizer(longPress)
        
        self.table.estimatedRowHeight = tableCellHeight
        self.table.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func configureToolbarView() {
        
        refreshToolbarItems()

    }
    
    
    // MARK: --------------------------------
    // MARK: Action Configuration Methods
    // MARK: --------------------------------
    
    func segmentChanged() {
        
        selectedSegment = segmentedControl.selectedSegmentIndex
        
        switch (selectedSegment) {
            
        case 0:
            descriptionLabel.attributedText = formatDescLabelText(progressDescription)
            
        case 1:
            descriptionLabel.attributedText = formatDescLabelText(planDescription)
            
        case 2:
            descriptionLabel.attributedText = formatDescLabelText(problemDescription)
            
        default:
            descriptionLabel.text = ""
        }
        
        self.determineNoPPPItemLabelVisibility()
        table.reloadData()
        
    }
    
    func add() {
        
        let mvc = AddPPPViewController(nibName: "AddPPPViewController", bundle: NSBundle.mainBundle())
        mvc.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        mvc.selectedSegment = selectedSegment //pass the selected segment to create the correct PPP instance
        
        let nc = UINavigationController(rootViewController: mvc)
        
        nc.navigationBar.barTintColor = UIColor.blackColor()
        nc.navigationBar.tintColor = UIColor.whiteColor()
        nc.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        self.navigationController?.presentViewController(nc, animated: true, completion: nil)
    }
    

    @IBAction func actionPressed(sender: AnyObject) {

        let overlayVC = SubmitPopUpViewController(nibName: "SubmitPopUpViewController", bundle: NSBundle.mainBundle())
        overlayVC.transitioningDelegate = overlayTransitioningDelegate
        overlayVC.modalPresentationStyle = .Custom
        overlayVC.vc = self
        self.presentViewController(overlayVC, animated: true, completion: nil)
    }
    
    func animateSubmit() {
        
        self.table.reloadData()
        
        var submitAlert = UIAlertController(title: "Brief Successfully Submitted", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        var okayActionButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { action in
            println("")
            self.navigationController?.popToRootViewControllerAnimated(true)
        })
        
        submitAlert.addAction(okayActionButton)
        
        self.presentViewController(submitAlert, animated: true, completion: nil)
        

    }
    
    @IBAction func deleteBrief(sender: AnyObject) {
        
        var alertView = UIAlertController(title: "Delete Brief?", message: nil, preferredStyle: .ActionSheet)
        
        var cancelActionButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alertAction: UIAlertAction!) in
            })
        
        var deleteActionButton = UIAlertAction(title: "Delete", style: .Destructive, handler: {
            (alertAction: UIAlertAction!) in
            
            //delete the iCloud copy
            var recordID = CKRecordID(recordName: user.getDraftBrief().id)
            var record = CKRecord(recordType: "Brief", recordID: recordID)
            self.cloudManager.deleteRecord(record)
            
            //delete the local copy
            user.deleteBrief()
            
            self.navigationController?.popToRootViewControllerAnimated(true)
            
            })

        alertView.addAction(cancelActionButton)
        alertView.addAction(deleteActionButton)
        
        self.presentViewController(alertView, animated: true, completion: {})
    }
    
    func longPressGestureRecognized(longPress: UILongPressGestureRecognizer) {
        
        var state: UIGestureRecognizerState = longPress.state
        var location: CGPoint = longPress.locationInView(table)
        var indexPath: NSIndexPath? = table.indexPathForRowAtPoint(location)
        var currentIndexPath: NSIndexPath?
            
        switch (state) {
        case .Began:
            
            if let indexPath = indexPath {
                
                sourceIndexPath = indexPath
                
                if let cell = table.cellForRowAtIndexPath(indexPath) {
                    
                    // Take a snapshot of the selected row using helper method.
                    snapshot = self.customSnapshotFromView(cell)
                    
                    // Add the snapshot as subview, centered at cell's center...
                    var center = cell.center
                    snapshot!.center = center
                    snapshot!.alpha = 0.0;
                    table.addSubview(snapshot!)
                    
                    UIView.animateWithDuration(0.25, animations: {
                        
                        // Offset for gesture location.
                        center.y = location.y;
                        self.snapshot!.center = center;
                        self.snapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05);
                        self.snapshot!.alpha = 0.98;
                        cell.hidden = true
                        
                        }, completion: nil)
                    
                    cell.hidden = false
                    
                }
                

            }
            
            break
        
        case .Changed:
            
            var center = snapshot!.center;
            center.y = location.y;
            snapshot!.center = center;
            
            // Is destination valid and is it different from source?
            if let indexPath = indexPath {
                if (!indexPath.isEqual(sourceIndexPath)) {
                    
                    // ... update data source.
                    switch (selectedSegment) {
                        
                    case 0:
                        user.getDraftBrief().moveProgress(sourceIndexPath!.row, to: indexPath.row)
                        
                    case 1:
                        user.getDraftBrief().movePlan(sourceIndexPath!.row, to: indexPath.row)
                        
                    case 2:
                        user.getDraftBrief().moveProblem(sourceIndexPath!.row, to: indexPath.row)
                        
                    default:
                        println("Nothing Selected")
                    }
                    
                    // ... move the rows.
                    table.moveRowAtIndexPath(sourceIndexPath!, toIndexPath: indexPath)
                    
                    // ... and update source so it is in sync with UI changes.
                    sourceIndexPath = indexPath;
                }
            }
            
            break;

        default:
            
            //Clean up.
            if let cell = table.cellForRowAtIndexPath(sourceIndexPath!) {
                UIView.animateWithDuration(0.2, animations: {
                    
                    self.snapshot!.center = cell.center;
                    self.snapshot!.transform = CGAffineTransformIdentity;
                    self.snapshot!.alpha = 0.0;
                    
                    // Undo the black-out effect we did.
                    cell.backgroundColor = UIColor.whiteColor()
                    
                    }, completion: {
                        (value: Bool) in
                        self.snapshot!.removeFromSuperview()
                        self.snapshot = nil;
                })
                
                sourceIndexPath = nil;
                break;
            }

        }
        
    }
    
    func animateBriefDelete() {
        
        UIView.animateWithDuration(0.80,  animations: {
            
            UIView.setAnimationCurve(.EaseInOut)
            UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromRight, forView: self.view, cache: false)
            
            }, completion: {
                (value: Bool) in

            })
        
    }
    
    // Returns a customized snapshot of a given view
    func customSnapshotFromView(inputView:UIView) -> UIView {
        
        table.reloadData()
        
        var snapshot  = inputView.snapshotViewAfterScreenUpdates(true)
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0.0;
        snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
        snapshot.layer.shadowRadius = 5.0;
        snapshot.layer.shadowOpacity = 0.4;
            
        
        return snapshot;
        
    }
    


    // MARK: --------------------------------
    // MARK: Helper methods
    // MARK: --------------------------------
    
    func formatDescLabelText(description: String) -> NSAttributedString {
        var attributedText = NSMutableAttributedString(string: description)
        attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 14)!, range: NSMakeRange(0, countElements(description)))
        
        return attributedText
    }
    
    func refreshToolbarItems() {
        
        if (!user.getDraftBrief().isEmpty()) {
            deleteButton.enabled = true
            actionButton.enabled = true
        } else {
            deleteButton.enabled = false
            actionButton.enabled = false
        }
        
    }
    
    func determineNoPPPItemLabelVisibility() {
        
        // if the comment count is 0 then hide the table and show the label
        switch (selectedSegment) {
            
        case 0:
            if (user.getDraftBrief().progress.count == 0) {
                self.noItemLabel.text = "There are no Progress items in this brief. Click the '+' button to add a new Progress item."
                self.noItemLabel.hidden = false
                
            } else {
                
                self.noItemLabel.hidden = true
                
            }
            
        case 1:
            if (user.getDraftBrief().plans.count == 0) {
                self.noItemLabel.text = "There are no Plans in this brief. Click the '+' button to add a new Plan."
                self.noItemLabel.hidden = false
                
            } else {
                
                self.noItemLabel.hidden = true
                
            }
            
        case 2:
            if (user.getDraftBrief().problems.count == 0) {
                self.noItemLabel.text = "There are no Problems in this brief. Click the '+' button to add a new Problem."
                self.noItemLabel.hidden = false
                
            } else {
                
                self.noItemLabel.hidden = true
                
            }
            
        default:
            self.noItemLabel.text = ""
            self.noItemLabel.hidden = true

            
        }
    }

}


// MARK: --------------------------------
// MARK: UITableViewDelegate Methods
// MARK: --------------------------------

extension ComposeViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {
        
        let mvc = AddPPPViewController(nibName: "AddPPPViewController", bundle: NSBundle.mainBundle())
        mvc.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        mvc.selectedSegment = selectedSegment //pass the selected segment to create the correct PPP instance
        mvc.selectedPPPElement = indexPath.row
        
        let nc = UINavigationController(rootViewController: mvc)
        nc.navigationBar.barTintColor = UIColor.blackColor()
        nc.navigationBar.tintColor = UIColor.whiteColor()
        nc.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        self.navigationController?.presentViewController(nc, animated: true, completion: nil)
    }
    
}

// MARK: --------------------------------
// MARK: UITableViewDatasource methods
// MARK: --------------------------------

extension ComposeViewController: UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (selectedSegment) {
            
        case 0:
            return user.getDraftBrief().progress.count
            
        case 1:
            return user.getDraftBrief().plans.count
            
        case 2:
            return user.getDraftBrief().problems.count
            
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = table.dequeueReusableCellWithIdentifier(cellName, forIndexPath: indexPath) as ComposeItemTableViewCell
        
        var text:String
        var id: String
        
        var draftBrief = user.getDraftBrief()
        
        switch (selectedSegment) {
            
            
        case 0:
            text = draftBrief.progress[indexPath.row].getContent()
            id = draftBrief.progress[indexPath.row].getId()
            
        case 1:
            text = draftBrief.plans[indexPath.row].getContent()
            id = draftBrief.plans[indexPath.row].getId()
            
        case 2:
            text = draftBrief.problems[indexPath.row].getContent()
            id = draftBrief.problems[indexPath.row].getId()
            
        default:
            text = ""
            id = ""
        }
        
        cell.briefId = id
        cell.cellLabel.text = text
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            
            var draftBrief = user.getDraftBrief()
            
            switch (selectedSegment) {
                
            case 0:
                
                // delete from iCloud
                var progress = draftBrief.progress[indexPath.row]
                var recordID = CKRecordID(recordName: progress.id)
                var record = CKRecord(recordType: "Progress", recordID: recordID)
                cloudManager.deleteRecord(record)
                
                // delete from local model
                draftBrief.deleteProgress(indexPath.row)
                
            case 1:
                
                // delete from iCloud
                var plan = draftBrief.plans[indexPath.row]
                var recordID = CKRecordID(recordName: plan.id)
                var record = CKRecord(recordType: "Plan", recordID: recordID)
                cloudManager.deleteRecord(record)
                
                // delete from local model
                draftBrief.deletePlan(indexPath.row)
                
            case 2:
                
                // delete from iCloud
                var problem = draftBrief.problems[indexPath.row]
                var recordID = CKRecordID(recordName: problem.id)
                var record = CKRecord(recordType: "Problem", recordID: recordID)
                cloudManager.deleteRecord(record)
                
                // delete from local model
                draftBrief.deleteProblem(indexPath.row)
                
            default:
                table.reloadData()
            }
            
            refreshToolbarItems()
            
            var cellToDelete = NSIndexPath(index: indexPath.row)
            table.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            determineNoPPPItemLabelVisibility()
        }
    }
}