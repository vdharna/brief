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
    
    private var progressDS = ["1", "2", "3"]
    private var plansDS = ["A", "B", "C"]
    private var problemsDS = ["X", "Y", "Z"]
    
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
        
        //setup the tableview
        setupTableView()
        
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
        
        // Stops a string reference cycle from happening
        weak var weakCell = cell
        
        cell.flagActionClosure = {
            let strongCell = weakCell
            
            var alert = UIAlertView(title: "Action", message: "Flag Button Clicked", delegate: nil, cancelButtonTitle: "Cancel")
            alert.show()
            
            var image = UIImage(named: "flag_icon_selected.png")
            strongCell!.flagImage.image = image
        }
        
        cell.commentActionClosure = {
            
            var alert = UIAlertView(title: "Action", message: "Comment Button Clicked", delegate: nil, cancelButtonTitle: "Cancel")
            alert.show()
        }
        
        cell.shareActionClosure = {
            
            var alert = UIAlertView(title: "Action", message: "Share Button Clicked", delegate: nil, cancelButtonTitle: "Cancel")
            alert.show()
        }

    
        switch(indexPath.section) {
        case 0: cell.cellLabel.text = progressDS[indexPath.row] + ": iOS 8 is the biggest iOS release ever — for developers and everyone else. But that wasn’t the goal. We simply set out to create the most natural experience."
        case 1: cell.cellLabel.text = plansDS[indexPath.row] + ": iOS 8 is the biggest iOS release ever — for developers and everyone else. But that wasn’t the goal. We simply set out to create the most natural experience."
        case 2: cell.cellLabel.text = problemsDS[indexPath.row] + ": iOS 8 is the biggest iOS release ever — for developers and everyone else. But that wasn’t the goal. We simply set out to create the most natural experience."
        default: cell.cellLabel.text = "iOS 8 is the biggest iOS release ever — for developers and everyone else. But that wasn’t the goal. We simply set out to create the most natural experience."
        
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
        case 0: return progressDS.count
        case 1: return plansDS.count
        case 2: return problemsDS.count
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

}
