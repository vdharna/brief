//
//  SubmitPopUpViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 9/1/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit
import QuartzCore

class SubmitPopUpViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var submit: UIButton!
    
    var parentController: ComposeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        self.popUpView.layer.cornerRadius = 5;
        self.popUpView.layer.shadowOpacity = 0.8;
        self.popUpView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        // Do any additional setup after loading the view from its nib.
        
        self.closeButton.addTarget(parentController, action: Selector("cancel"), forControlEvents: UIControlEvents.TouchDown)
        self.submit.addTarget(parentController, action: Selector("submitBrief"), forControlEvents: UIControlEvents.TouchDown)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAnimate() {
        
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0
        UIView.animateWithDuration(0.25, animations: {
            
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1, 1)
        })
        
    }

    
    func submitAnimate() {
                
        user.submitBrief({ completed in
            
            UIView.animateWithDuration(0.25, animations: {
                
                self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
                self.view.alpha = 0.0
                
                }, completion: { completed in
                    
                    if (completed) {
                        self.view.removeFromSuperview()
                        self.parentController.navigationController.popToRootViewControllerAnimated(true)
                    }
            })

        })
        
    }
    
    func cancelAnimate() {
        
        UIView.animateWithDuration(0.25, animations: {
            
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0
            
            }, completion: { completed in
                
                if (completed) {
                    self.view.removeFromSuperview()
                }
        })
        
        
    }
    
    
    func showInView(aView: UIView, vc: ComposeViewController) {
        self.parentController = vc
        
        dispatch_async(dispatch_get_main_queue(), {
            
            aView.addSubview(self.view)
            self.showAnimate()
        })
    }

}
