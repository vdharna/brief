//
//  SecondViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/8/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class CreateBriefController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate {
    
    var descriptionLabel:UILabel?
    
    let progressDescription = "List three to five accomplishments, finished items and closed tasks for the current reporting period"
    let planDescription = "List your goals and objectives for the next reporting period. Keep the list to between three and five items."
    let problemDescription = "List items that are stuck and can’t be finished. Problems often need escalation and help from someone else."
    
    let segmentedControl = UISegmentedControl(items: ["Progress", "Plans", "Problems"])
    var selectedSegment = 0 //remember which segment was selected
    
    var deleteButton: UIBarButtonItem?
    var actionButton: UIBarButtonItem?
    var toolBar: UIToolbar?
    
    var pppTable:UITableView?
    let tableCellHeight:CGFloat = 100
    
    var snapshot: UIView?        ///< A snapshot of the row user is moving.
    var sourceIndexPath:NSIndexPath? ///< Initial index path, where gesture begins.
    
    // ==========================================
    // MARK: lifecycle methods
    // ==========================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSegmentView()
        setupDescriptionLabel()
        setupTableView()
        setupToolbarView()
 
    }
    
    func setupSegmentView() {
        //set the segment in the navigation bar
        segmentedControl.addTarget(self, action: Selector("segmentChanged"), forControlEvents: .ValueChanged)
        segmentedControl.selectedSegmentIndex = selectedSegment //defaults to the first segment
        segmentedControl.sizeToFit()
        self.navigationItem.titleView = segmentedControl
        //add the + button
        var addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("add"))
        self.navigationItem.rightBarButtonItem = addButton;
    }
    
    func setupDescriptionLabel() {
        // set the attributedString to the label for proper font rendering
        descriptionLabel = UILabel(frame: CGRectMake(self.view.frame.origin.x + 10, self.view.frame.origin.y + 80, self.view.frame.width - 30, 88))
        
        var formattedText = formatDescLabelText(progressDescription)
        descriptionLabel!.attributedText = formattedText
        //use this to align the text to the top
        descriptionLabel!.numberOfLines = 0;
        descriptionLabel!.sizeToFit()
        
        //add to the subview
        self.view.addSubview(descriptionLabel)
    }
    
    func setupTableView() {
        
        //table view set-up
        pppTable = UITableView(frame: CGRectMake(self.view.frame.origin.x, descriptionLabel!.frame.origin.y + 70, self.view.frame.width, 374))
        pppTable!.separatorStyle = UITableViewCellSeparatorStyle.None
        pppTable!.delegate = self
        pppTable!.dataSource = self
        
        //for reusable cells
        self.pppTable!.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        self.pppTable!.allowsMultipleSelectionDuringEditing = false
        
        //add long tap gesture recognizer
        var longPress = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognized:")
        self.pppTable!.addGestureRecognizer(longPress)
        
        //add to the main view
        self.view.addSubview(pppTable)
        
    }
    
    func setupToolbarView() {
        //tool bar
        var rect = CGRectMake(self.view.frame.origin.x, 524, self.view.frame.size.width, 44)
        toolBar = UIToolbar(frame: rect)
        toolBar!.barTintColor = UIColor.blackColor()
        
        deleteButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self,
            action: "deleteBrief")
        deleteButton!.tintColor = UIColor.whiteColor()
        deleteButton!.enabled = false
        
        actionButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self,
            action: "actionBrief")
        actionButton!.tintColor = UIColor.whiteColor()
        actionButton!.enabled = false
        
        var flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        flexibleSpace.width = 10
        
        toolBar!.items = [deleteButton!, flexibleSpace, actionButton!]
        self.view.addSubview(toolBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController.navigationBarHidden = false
        segmentedControl.selectedSegmentIndex = selectedSegment //sets to last selected segment
        
        if (!user.brief.isEmpty()) {
            deleteButton!.enabled = true
            actionButton!.enabled = true
        } else {
            deleteButton!.enabled = false
            actionButton!.enabled = false
        }
        
        pppTable!.reloadData()
        
    }
    
    override func viewWillDisappear(animated: Bool)  {
        
    }
    
    // ==========================================
    // MARK: action methods
    // ==========================================
    
    func segmentChanged() {
        
        selectedSegment = segmentedControl.selectedSegmentIndex
        
        switch (selectedSegment) {
            
        case 0:
            descriptionLabel!.attributedText = formatDescLabelText(progressDescription)
            
        case 1:
            descriptionLabel!.attributedText = formatDescLabelText(planDescription)
            
        case 2:
            descriptionLabel!.attributedText = formatDescLabelText(problemDescription)
            
        default:
            descriptionLabel!.text = ""
        }
        
        pppTable!.reloadData()
        
    }
    
    func add() {
        var addPPPVC = AddPPPController(nibName: nil, bundle: nil)
        addPPPVC.selectedSegment = selectedSegment //pass the selected segment to create the correct PPP instance
        self.navigationController.presentViewController(addPPPVC, animated: true, completion: nil)
    }
    
    func actionBrief() {

    }
    
    func deleteBrief() {
        
        var actionSheet = UIActionSheet(title: "Delete Brief?", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Delete" )
        actionSheet.showInView(UIApplication.sharedApplication().keyWindow)
    }
    
    
    func longPressGestureRecognized(longPress: UILongPressGestureRecognizer) {
        
        var state: UIGestureRecognizerState = longPress.state
        var location: CGPoint = longPress.locationInView(self.pppTable!)
        var indexPath: NSIndexPath? = self.pppTable!.indexPathForRowAtPoint(location)
            
        switch (state) {
        case .Began:
            if(indexPath) {

                sourceIndexPath = indexPath
                
                var cell = pppTable!.cellForRowAtIndexPath(indexPath)
                
                // Take a snapshot of the selected row using helper method.
                snapshot = self.customSnapshotFromView(cell)
                
                // Add the snapshot as subview, centered at cell's center...
                var center = cell.center
                snapshot!.center = center
                snapshot!.alpha = 0.0;
                self.pppTable!.addSubview(snapshot)
                
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
            
            break
        
        case .Changed:
            
            var center = snapshot!.center;
            center.y = location.y;
            snapshot!.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && !indexPath!.isEqual(sourceIndexPath)) {
                
                // ... update data source.
                switch (selectedSegment) {
                    
                case 0:
                    user.brief.moveProgress(sourceIndexPath!.row, to: indexPath!.row)
                
                case 1:
                    user.brief.movePlan(sourceIndexPath!.row, to: indexPath!.row)
                    
                case 2:
                    user.brief.moveProblem(sourceIndexPath!.row, to: indexPath!.row)
                    
                default:
                    println("Nothing Selected")
                }
                
                // ... move the rows.
                self.pppTable!.moveRowAtIndexPath(sourceIndexPath, toIndexPath: indexPath)
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            
            break;

        default:
            
            //Clean up.
            var cell = self.pppTable!.cellForRowAtIndexPath(sourceIndexPath)
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
    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {

        switch(buttonIndex) {
            
        case 0: //discard
            
            user.brief.delete()
            selectedSegment = 0
            self.pppTable!.reloadData()
            animateBriefDelete()
            self.deleteButton!.enabled = false
            self.actionButton!.enabled = false
        case 1: //cancel
            break
            
        default:
            break
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
        
        var snapshot = inputView.snapshotViewAfterScreenUpdates(true)
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0.0;
        snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
        snapshot.layer.shadowRadius = 5.0;
        snapshot.layer.shadowOpacity = 0.4;
        
        return snapshot;
        
    }

    
    // ==========================================
    // MARK: tableview methods
    // ==========================================
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        
        switch (selectedSegment) {
            
        case 0:
            return user.brief.progress.count
            
        case 1:
            return user.brief.plans.count
       
        case 2:
            return user.brief.problems.count
            
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        var cell: UITableViewCell = pppTable!.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
       
        var text:String
        
        switch (selectedSegment) {
            
        case 0:
            text = user.brief.progress[indexPath.row].content
            
        case 1:
            text = user.brief.plans[indexPath.row].content
            
        case 2:
            text = user.brief.problems[indexPath.row].content
            
        default:
            text = ""
        }
        
        cell.textLabel.text = text
        cell.textLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        cell.textLabel.numberOfLines = 5
        //cell.backgroundColor = UIColor.lightGrayColor()
        cell.accessoryType = .DisclosureIndicator
        cell.imageView.image = UIImage(named: "cell-30pt.png")
        
        //following code keeps the cell images flush between cell
        var itemSize = CGSizeMake(30, 100)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.mainScreen().scale);
        var imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        cell.imageView.image.drawInRect(imageRect)
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return cell
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return tableCellHeight
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)  {
        
        var addPPPVC = AddPPPController(nibName: nil, bundle: nil)
        addPPPVC.selectedSegment = selectedSegment //pass the selected segment to create the correct PPP instance
        addPPPVC.selectedPPPElement = indexPath.row
        self.navigationController.presentViewController(addPPPVC, animated: true, completion: nil)
        
    }
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == .Delete) {
            
            switch (selectedSegment) {
                
            case 0:
                user.brief.deleteProgress(indexPath.row)
                
            case 1:
                user.brief.deletePlan(indexPath.row)
                
            case 2:
                user.brief.deleteProblem(indexPath.row)
                
            default:
                self.pppTable!.reloadData()
            }
            
            if (!user.brief.isEmpty()) {
                deleteButton!.enabled = true
                actionButton!.enabled = true
            } else {
                deleteButton!.enabled = false
                actionButton!.enabled = false
            }
            var cellToDelete = NSIndexPath(index: indexPath.row)
            pppTable!.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
 
    // ==========================================
    // MARK: helper methods
    // ==========================================
    
    func formatDescLabelText(description: String) -> NSAttributedString {
        var attributedText = NSMutableAttributedString(string: description)
        attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 14), range: NSMakeRange(0, countElements(description)))
        
        return attributedText
    }
}

