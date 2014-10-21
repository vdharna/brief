//
//  VisibleTeamMembersViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 9/12/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit
import CloudKit

class VisibleTeamMembersViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    var cloudManager = BriefCloudManager()

    var progressView = ProgressView(frame: CGRectMake(0, 0, 300, 300))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        self.configureTableView()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // start the activity spinner
        self.table.hidden = true
        self.view.addSubview(progressView)
        user.getAllDiscoverableUsers({ completed in
            self.table.reloadData()
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
        var nib = UINib(nibName: "VisibleUserTableViewCell", bundle: NSBundle.mainBundle())
        self.table.registerNib(nib, forCellReuseIdentifier: "VisibleUserTableViewCell")
        self.table.allowsMultipleSelection = true
        
        self.table.estimatedRowHeight = 60
        self.table.rowHeight = UITableViewAutomaticDimension
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

// MARK: --------------------------------
// MARK: UITableViewDatasource methods
// MARK: --------------------------------

extension VisibleTeamMembersViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.discoverableUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var discoveredUser = user.discoverableUsers[indexPath.row]
        var cell = self.table.dequeueReusableCellWithIdentifier("VisibleUserTableViewCell") as VisibleUserTableViewCell
        var text = discoveredUser.getFirstName() + " " + discoveredUser.getLastName()
        
        if let recordName = discoveredUser.userInfo?.userRecordID.recordName {
            self.cloudManager.fetchRecordWithID(recordName, completionClosure: { record in
                
                if let preferredName = record.objectForKey("preferredName") as? String {
                    if (!preferredName.isEmpty) {
                        text = preferredName
                    }
                }
                
                cell.userName.text = text
                
                if let photoAsset = record.objectForKey("photo") as? CKAsset {
                    var image = UIImage(contentsOfFile: photoAsset.fileURL.path!)
                    cell.profileImage.image = image
                }
                
                if (indexPath.row + 1 == user.discoverableUsers.count) {
                    self.table.hidden = false
                    self.progressView.removeFromSuperview()
                }
                
            })
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.None
        
        return cell
    }
}

extension VisibleTeamMembersViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = self.table.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = self.table.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.None
    }
    
}
