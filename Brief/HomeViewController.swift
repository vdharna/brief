//
//  BriefHomeController.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/8/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit
import QuartzCore

class HomeViewController: UIViewController {
    
    @IBOutlet var composeButton: UIButton!
    @IBOutlet var composeLabel: UILabel!
    
    @IBOutlet var completedButton: UIButton!
    @IBOutlet var completedLabel: UILabel!
    
    var cbvc: MasterBriefViewController?
    
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
        setupNavBar()
    }
    
    
    func setupNavBar() {
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        switch (user.getDraftBrief().status) {
            
        case .New:
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

    }
    
    // ==========================================
    // MARK: action methods
    // ==========================================

    @IBAction func composeBrief(sender: AnyObject) {
        
        //prevent duplicate tap
        composeButton.enabled = false
        completedButton.enabled = false

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

}

