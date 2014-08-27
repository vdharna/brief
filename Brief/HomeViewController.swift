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
    let cloudManager = BriefCloudManager()
    
    var initialLoad = true
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //assign the constant
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // ==========================================
    // MARK: lifecycle methods
    // ==========================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        configureNavBar()
        
        self.composeButton.hidden = true
        self.composeLabel.hidden = true
        
        self.completedButton.hidden = true
        self.completedLabel.hidden = true
        
        // start the activity spinner
        var progressView = ProgressView(frame: CGRectMake(0, 0, 300, 300))
        self.view.addSubview(progressView)
        
        user.loadDraftBrief({ completed in
            
            user.loadCompletedBriefs({ completed in
                
                // when the loading of the draft brief completes
                self.configureButtons()
                progressView.removeFromSuperview()
                self.initialLoad = false
                if let name = user.preferredName {
                    self.userNameLabel.text = "Welcome \(user.preferredName!)"
                } else {
                    self.userNameLabel.text = "Welcome \(user.userInfo!.firstName)"
                }
            })
            
        })
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if (!self.initialLoad) {
            self.configureButtons()
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        var briefs = user.getCompletedBriefs()
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
        
        self.composeButton.hidden = false
        self.composeLabel.hidden = false
        
        self.completedButton.hidden = false
        self.completedLabel.hidden = false
        
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
        if (cbvc == nil || user.submittedBrief) {
            cbvc = MasterBriefViewController(nibName: "MasterBriefViewController", bundle: NSBundle.mainBundle())
            user.submittedBrief = false
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
    
}

