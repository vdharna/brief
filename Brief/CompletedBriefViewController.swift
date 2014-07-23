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
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Completed Briefs"
        
        // load the custom cell via NIB
        var nib = UINib(nibName: "CompletedBriefCell", bundle: nil)
        
        // Register this NIB, which contains the cell
        self.table.registerNib(nib, forCellReuseIdentifier: "CompletedBriefCell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ============================================
    // MARK: UITableViewDataSource implementation
    // ============================================
    
    // Asks the data source for a cell to insert in a particular location of the table view. (required)
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        // Get a new or recycled cell
        var cell = self.table.dequeueReusableCellWithIdentifier("CompletedBriefCell", forIndexPath: indexPath) as CompletedBriefCell

        cell.cellLabel.text = "One of the greatest things about the iOS platform and applications people see on it is its beauty. Smooth gradients, consistent transitions."
        
        return cell
    }
    
    // Asks the data source to return the number of sections in the table view.
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        
        return 3
        
    }

    // Tells the data source to return the number of rows in a given section of a table view. (required)
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        
        return 3
        
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


}
