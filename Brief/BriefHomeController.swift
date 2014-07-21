//
//  BriefHomeController.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/8/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class BriefHomeController: UIViewController {
    
    var createBriefVC: CreateBriefController?
    
    @IBOutlet var composeButton: UIButton!
    @IBOutlet var composeLabel: UILabel!
    
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var continueLabel: UILabel!
    
    @IBOutlet var completedButton: UIButton!
    @IBOutlet var completedLabel: UILabel!
    
    var composeButtonView:ComposeBriefButtonView?
    var completedButtonView:CompletedBriefButtonView?
    
    var origComposeRect:CGRect?
    var origCompleteRect:CGRect?
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // ==========================================
    // MARK: lifecycle methods
    // ==========================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        composeButtonView = ComposeBriefButtonView(frame: CGRectMake(0, 0, composeButton.frame.width, composeButton.frame.height))
        composeButton.addSubview(composeButtonView)
        
        completedButtonView = CompletedBriefButtonView(frame: CGRectMake(0, 0, completedButton.frame.width, completedButton.frame.height))
        completedButton.addSubview(completedButtonView)
        
        origComposeRect = composeButtonView!.bounds
        origCompleteRect = completedButtonView!.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController.navigationBarHidden = true
        self.navigationItem.title = ""
        
        //graphite color
        self.navigationController.navigationBar.barTintColor = UIColor.darkTextColor()
        self.navigationController.navigationBar.tintColor = UIColor.whiteColor()
        
        if (user.brief.isEmpty()) {
            continueButton.enabled = false
            continueLabel.enabled = false
        } else {
            continueButton.enabled = true
            continueLabel.enabled = true
        }
        
        if (origComposeRect!.size != composeButtonView!.bounds.size) {
            self.composeButtonView!.bounds = origComposeRect!
        }
        
        if (origCompleteRect!.size != completedButtonView!.bounds.size) {
            self.completedButtonView!.bounds = origCompleteRect!
        }
        
    }
    
    // ==========================================
    // MARK: action methods
    // ==========================================

    @IBAction func composeBrief(sender: AnyObject) {
        
        UIView.animateWithDuration(0.5, animations: {
            
            var rect = self.composeButtonView!.frame
            rect.size.height += 15
            rect.size.width += 15
            
            self.composeButtonView!.bounds = rect
            
            }, completion: {
                (value: Bool) in
                self.createBriefVC = CreateBriefController()
                self.navigationController.pushViewController(self.createBriefVC, animated: true)

            })
        

    }

    @IBAction func continueBrief(sender: AnyObject) {
        
        UIView.animateWithDuration(0.5, animations: {
            UIView.setAnimationRepeatAutoreverses(true)
            UIView.setAnimationRepeatCount(5.0)
            var rect = self.continueButton.frame
            rect.size.height += 15
            rect.size.width += 15
            
            self.continueButton.bounds = rect
            
            }, completion: {
                (value: Bool) in
                self.createBriefVC = CreateBriefController()
                self.navigationController.pushViewController(self.createBriefVC, animated: true)
            })
    }
    
    
    @IBAction func showCompletedBriefs(sender: AnyObject) {
        
        UIView.animateWithDuration(0.88, animations: {
            
            var rect = self.completedButtonView!.frame
            rect.size.height += 15
            rect.size.width += 15
            
            self.completedButtonView!.bounds = rect
            
            }, completion: {
                (value: Bool) in
                self.createBriefVC = CreateBriefController()
                self.navigationController.pushViewController(self.createBriefVC, animated: true)
                
            })
        
    }
}

