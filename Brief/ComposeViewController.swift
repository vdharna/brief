//
//  SecondViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/8/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

let characterLimit = 140

class ComposeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let progressDescription = "List your accomplishments, finished items and closed tasks for the current reporting period"
    let planDescription = "List your goals and objectives for the next reporting period"
    let problemDescription = "List items you can't finish and need escalation or help from someone else."
    
    let segmentedControl = UISegmentedControl(items: ["Progress", "Plans", "Problems"])
    
    let cellName = "ComposeBriefTableViewCell"
    let redCellImage = UIImage(named: "compose-table-cell-red.png")
    let greenCellImage = UIImage(named: "compose-table-cell-green.png")
    
    let tableCellHeight:CGFloat = 130
    
    
    var selectedSegment = 0 //remember which segment was selected
    
    var snapshot: UIView?        ///< A snapshot of the row user is moving.
    var sourceIndexPath:NSIndexPath? ///< Initial index path, where gesture begins.
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
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

        var formattedText = formatDescLabelText(progressDescription)
        descriptionLabel.attributedText = formattedText
        
        //use this to align the text to the top
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.sizeToFit()
    }
    
    func setupTableView() {
        table.separatorStyle = UITableViewCellSeparatorStyle.None
        table.delegate = self
        table.dataSource = self
        
        //for reusable cells
        // load the custom cell via NIB
        var nib = UINib(nibName: cellName, bundle: NSBundle.mainBundle())
        
        // Register this NIB, which contains the cell
        table.registerNib(nib, forCellReuseIdentifier: cellName)
        
       // self.pppTable!.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        table.allowsMultipleSelectionDuringEditing = false
        
        //add long tap gesture recognizer
        var longPress = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognized:")
        table.addGestureRecognizer(longPress)
                
    }
    
    func setupToolbarView() {
        
        refreshToolbarItems()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController.navigationBarHidden = false
        segmentedControl.selectedSegmentIndex = selectedSegment //sets to last selected segment
        
        refreshToolbarItems()
        
        table.reloadData()
        
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
            descriptionLabel.attributedText = formatDescLabelText(progressDescription)
            
        case 1:
            descriptionLabel.attributedText = formatDescLabelText(planDescription)
            
        case 2:
            descriptionLabel.attributedText = formatDescLabelText(problemDescription)
            
        default:
            descriptionLabel.text = ""
        }
        
        table.reloadData()
        
    }
    
    func add() {
        
        let mvc = AddPPPViewController(nibName: "AddPPPViewController", bundle: NSBundle.mainBundle())
        mvc.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        mvc.selectedSegment = selectedSegment //pass the selected segment to create the correct PPP instance
        
        let nc = UINavigationController(rootViewController: mvc)
        //nav bar setup
        nc.navigationBar.barTintColor = UIColor.blackColor()
        nc.navigationBar.tintColor = UIColor.whiteColor()
        nc.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        self.navigationController.presentViewController(nc, animated: true, completion: nil)
    }
    

    @IBAction func actionBrief(sender: AnyObject) {
        
        var alert = UIAlertView(title: "Action", message: "Action Button Clicked", delegate: nil, cancelButtonTitle: "Cancel")
        alert.show()
    }
    
    @IBAction func deleteBrief(sender: AnyObject) {
        
        var alertView = UIAlertController(title: "Delete Brief?", message: nil, preferredStyle: .ActionSheet)
        
        var cancelActionButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alertAction: UIAlertAction!) in
            })
        
        var deleteActionButton = UIAlertAction(title: "Delete", style: .Destructive, handler: {
            (alertAction: UIAlertAction!) in
            user.brief.delete()
            self.selectedSegment = 0
            self.table.reloadData()
            self.animateBriefDelete()
            self.deleteButton.enabled = false
            self.actionButton.enabled = false
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
            if((indexPath) != nil) {

                sourceIndexPath = indexPath
                
                var cell = table.cellForRowAtIndexPath(indexPath)
                
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
            
            break
        
        case .Changed:
            
            var center = snapshot!.center;
            center.y = location.y;
            snapshot!.center = center;
            
            // Is destination valid and is it different from source?
            if ((indexPath != nil) && !indexPath!.isEqual(sourceIndexPath)) {
                
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
                table.moveRowAtIndexPath(sourceIndexPath, toIndexPath: indexPath)
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            
            break;

        default:
            
            //Clean up.
            var cell = table.cellForRowAtIndexPath(sourceIndexPath)
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

    
    // ============================================
    // MARK: UITableViewDataSource implementation
    // ============================================
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
        
        var cell = table.dequeueReusableCellWithIdentifier(cellName, forIndexPath: indexPath) as ComposeBriefTableViewCell
       
        var text:String
        var id: Int
        
        switch (selectedSegment) {
            
        case 0:
            text = user.brief.progress[indexPath.row].getContent()
            id = user.brief.progress[indexPath.row].getId()
            
        case 1:
            text = user.brief.plans[indexPath.row].getContent()
            id = user.brief.plans[indexPath.row].getId()
            
        case 2:
            text = user.brief.problems[indexPath.row].getContent()
            id = user.brief.problems[indexPath.row].getId()
            
        default:
            text = ""
            id = 0
        }
        
        cell.tag = id
        cell.cellLabel.text = text
        cell.cellLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        cell.cellLabel.numberOfLines = 6
        cell.accessoryType = .DisclosureIndicator
        if (cell.cellLabel.text.utf16Count > characterLimit) {
            cell.cellImage.image = redCellImage
        } else {
            cell.cellImage.image = greenCellImage

        }
        
        return cell
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
                table.reloadData()
            }
            
            refreshToolbarItems()
            
            var cellToDelete = NSIndexPath(index: indexPath.row)
            table.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    // ============================================
    // MARK: UITableViewDelegate implementation
    // ============================================
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return tableCellHeight
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)  {
        
        println("Selected Index: \(indexPath)")
        var mvc = AddPPPViewController(nibName: "AddPPPViewController", bundle: NSBundle.mainBundle())
        mvc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        mvc.selectedSegment = selectedSegment //pass the selected segment to create the correct PPP instance
        mvc.selectedPPPElement = indexPath.row
        self.navigationController.presentViewController(mvc, animated: true, completion: nil)
        
    }


    // ==========================================
    // MARK: helper methods
    // ==========================================
    
    func formatDescLabelText(description: String) -> NSAttributedString {
        var attributedText = NSMutableAttributedString(string: description)
        attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 14), range: NSMakeRange(0, countElements(description)))
        
        return attributedText
    }
    
    func refreshToolbarItems() {
        
        if (!user.brief.isEmpty()) {
            deleteButton.enabled = true
            actionButton.enabled = true
        } else {
            deleteButton.enabled = false
            actionButton.enabled = false
        }
        
    }
}

