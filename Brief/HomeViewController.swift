//
//  BriefHomeController.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/8/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit
import QuartzCore
import CloudKit

class HomeViewController: UIViewController {
    
    @IBOutlet var composeButton: UIButton!
    @IBOutlet var composeLabel: UILabel!
    
    @IBOutlet var completedButton: UIButton!
    @IBOutlet var completedLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    var cbvc: MasterBriefViewController?
    var cloudManager = BriefCloudManager()
    
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //assign the constant
    }
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    // ==========================================
    // MARK: lifecycle methods
    // ==========================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureNavBar()
        
        // enhance this code to pull user info locally and using identity management prior to hitting iCloud
        self.cloudManager.requestDiscoverabilityPermission({ discoverability in
            if (discoverability) {
                
                self.cloudManager.discoverUserInfo({ userInfo in
                    
                    // assign the user information
                    user.userInfo = userInfo
                    self.userNameLabel.text = "Welcome \(userInfo.firstName)"
                    
                    self.cloudManager.queryForDraftBrief({ records in
                        
                        if (records.count > 0) {
                            
                            // pull the first record
                            var record = records.first
                            
                            var id = record?.recordID.recordName
                            var statusRaw = record?.objectForKey("status") as NSNumber
                            var status = Status.fromRaw(statusRaw)
                            
                            var draftBrief = Brief(status: status!)
                            draftBrief.id = id!
                            
                            user.draftBrief = draftBrief
                            
                            self.loadProgressItemsFromiCloud()
                            self.loadPlanItemsFromiCloud()
                            self.loadProblemItemsFromiCloud()
                        }
                        
                        self.configureButtons()
                    })
                    
                    
                });
                
            } else {
                
                var alert = UIAlertController(title: "Brief", message: "Getting your Briefs requires permission.", preferredStyle: UIAlertControllerStyle.Alert)
                
                var action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { alert in
                    self.dismissViewControllerAnimated(true, completion: nil)
                });
                
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        });
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.configureButtons()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

    }
    
    func configureButtons() {
        
        switch(user.getDraftBrief().status) {
            
        case .IsNew:
            self.composeButton.imageView.image = UIImage(named: "compose.png")
            self.composeLabel.text = "COMPOSE"
            
        case .InProgress:
            self.composeButton.imageView.image = UIImage(named: "continue.png")
            self.composeLabel.text = "CONTINUE"
            
        default:
            self.composeButton.imageView.image = UIImage(named: "compose.png")
            self.composeLabel.text = "COMPOSE"
        }

        
    }
    
    func configureNavBar() {
        
        self.navigationItem.title = ""
        
        // this will appear as the title in the navigation bar
        var label = UILabel()
        label.text = "Brief"
        label.backgroundColor = UIColor.clearColor()
        label.font = UIFont.boldSystemFontOfSize(25.0)
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = label;
        label.sizeToFit()
        
        //setup the gear
        var gearImage = UIImage(named: "gear.png")
        var gearButton = UIBarButtonItem(image: gearImage, style: .Plain, target: self, action: "settings")
        self.navigationItem.rightBarButtonItem = gearButton;
        
    }
    
    // ==========================================
    // MARK: action methods
    // ==========================================

    @IBAction func composeBrief(sender: AnyObject) {
        
        //prevent duplicate tap
        composeButton.enabled = false
        completedButton.enabled = false
        
        // create the record in iCloud
        var draftBrief = user.getDraftBrief()
        // only save if it's new
        if (draftBrief.status == Status.IsNew) {
            draftBrief.status = .InProgress
            self.cloudManager.addBriefRecord(draftBrief, completionClosure: { record in
                // assign the record id generated from iCloud to the draft brief
                draftBrief.id = record.recordID.recordName
            })
        }


        var cvc = ComposeViewController(nibName: "ComposeViewController", bundle: NSBundle.mainBundle())
        self.navigationController.pushViewController(cvc, animated: true)
        self.composeButton.enabled = true
        self.completedButton.enabled = true
        
    }
    
    @IBAction func showCompletedBriefs(sender: AnyObject) {
                
        //prevent duplicate tap
        composeButton.enabled = false
        completedButton.enabled = false
        if (cbvc == nil) {
            cbvc = MasterBriefViewController(nibName: "MasterBriefViewController", bundle: NSBundle.mainBundle())
        }
        self.navigationController.pushViewController(cbvc, animated: true)
        self.composeButton.enabled = true
        self.completedButton.enabled = true
    }
    
    func settings() {
        println("settings")
    }

    @IBAction func cloudKitPressed(sender: AnyObject) {
        
        var cloudManager = BriefCloudManager()
        cloudManager.requestDiscoverabilityPermission({discoverability in
            if (discoverability) {
                cloudManager.discoverUserInfo({userInfo in
                    println("\(userInfo.firstName)")
                    println("\(userInfo.lastName)")
                });
            } 
        });
        
        cloudManager.queryForDraftBrief({ record in
            println(record)
        })
        
        cloudManager.queryForItemRecordsWithReferenceNamed(user.getDraftBrief().id, recordType: "Progress", completionClosure: { records in
            
            println("\(records)")
        })
        
    }
    
    
    // MARK: --------------------------------
    // MARK: iCloud load methods
    // MARK: --------------------------------
    
    func loadProgressItemsFromiCloud() {
        
        var briefId = user.getDraftBrief().id
        self.cloudManager.queryForItemRecordsWithReferenceNamed(briefId, recordType: "Progress", completionClosure: { records in
            
            for i in (0 ..< records.count) {
                var id = records[i].recordID.recordName
                var content = records[i].objectForKey("content") as String
                
                var progress = Progress(content: content)
                progress.id = id
                
                user.getDraftBrief().addProgress(progress)
            }
            
            
            
        })
    }
    
    func loadPlanItemsFromiCloud() {
        
        var briefId = user.getDraftBrief().id
        self.cloudManager.queryForItemRecordsWithReferenceNamed(briefId, recordType: "Plan", completionClosure: { records in
            
            for i in (0 ..< records.count) {
                var id = records[i].recordID.recordName
                var content = records[i].objectForKey("content") as String
                
                var plan = Plan(content: content)
                plan.id = id
                
                user.getDraftBrief().addPlan(plan)
            }
            
            
            
        })
    }
    
    func loadProblemItemsFromiCloud() {
        
        var briefId = user.getDraftBrief().id
        self.cloudManager.queryForItemRecordsWithReferenceNamed(briefId, recordType: "Problem", completionClosure: { records in
            
            for i in (0 ..< records.count) {
                var id = records[i].recordID.recordName
                var content = records[i].objectForKey("content") as String
                
                var problem = Problem(content: content)
                problem.id = id
                
                user.getDraftBrief().addProblem(problem)
            }
            
            
            
        })
    }
}

