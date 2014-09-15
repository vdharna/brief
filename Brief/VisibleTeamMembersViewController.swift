//
//  VisibleTeamMembersViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 9/12/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class VisibleTeamMembersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    var cloudManager = BriefCloudManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        self.configureTableView()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // start the activity spinner
        var progressView = ProgressView(frame: CGRectMake(0, 0, 300, 300))
        self.view.addSubview(progressView)
        user.getAllDiscoverableUsers({ completed in
            self.table.reloadData()
            progressView.removeFromSuperview()
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureNavigationBar() {
        
        var saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: Selector("save"))
        var cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("dismissModal"))
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.title = "Available Users"
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    
    func configureTableView() {
        self.table.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        self.table.allowsMultipleSelection = true
    }
    

    // MARK: --------------------------------
    // MARK: UITableViewDatasource methods
    // MARK: --------------------------------
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var discoveredUser = user.discoverableUsers[indexPath.row]
        println(discoveredUser.userInfo?.userRecordID.recordName)
        var cell = self.table.dequeueReusableCellWithIdentifier("UITableViewCell") as UITableViewCell
        var text = discoveredUser.getFirstName() + " " + discoveredUser.getLastName()
        
        cell.textLabel?.text = text
        cell.accessoryType = UITableViewCellAccessoryType.None
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = self.table.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = self.table.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.None
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.discoverableUsers.count
    }
    
    // MARK: --------------------------------
    // MARK: Action methods
    // MARK: --------------------------------
    
    func dismissModal() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func save() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }


}
