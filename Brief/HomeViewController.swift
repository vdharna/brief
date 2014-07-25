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
    
    var cvc: ComposeViewController?
    
    @IBOutlet var composeButton: UIButton!
    @IBOutlet var composeLabel: UILabel!
    
    @IBOutlet var completedButton: UIButton!
    @IBOutlet var completedLabel: UILabel!
    
    var composeButtonView:ComposeBriefButtonView?
    var completedButtonView:CompletedBriefButtonView?
    
    var origComposeRect:CGRect?
    
    var circle = CALayer()
    var linePath = UIBezierPath()
    var hourLine = CAShapeLayer()
    var minuteLine = CAShapeLayer()
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //assign the constant
    }
    
    // ==========================================
    // MARK: lifecycle methods
    // ==========================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupComposeButton()
        setupHistoryButtonAlternate()
        setupNavBar()
    }
    
    func setupComposeButton() {
        composeButtonView = ComposeBriefButtonView(frame: CGRectMake(0, 0, composeButton.frame.width, composeButton.frame.height))
        composeButton.addSubview(composeButtonView)
        origComposeRect = composeButton.bounds
    }
    
    func setupContinueButton() {
        
    }
    
    func setupHistoryButton() {
        completedButtonView = CompletedBriefButtonView(frame: CGRectMake(0, 0, completedButton.frame.width, completedButton.frame.height))
        completedButton.addSubview(completedButtonView)
    }
    
    func setupHistoryButtonAlternate() {
        
        //draw the circle
        
        circle.bounds = completedButton!.bounds
        circle.position = completedButton!.center;
        circle.cornerRadius = completedButton!.bounds.width / 2
        circle.borderColor = UIColor.darkGrayColor().CGColor;
        circle.borderWidth = 1;
        
        //draw the hour line
        linePath.moveToPoint(completedButton!.center)
        linePath.addLineToPoint(CGPointMake(completedButton!.center.x, completedButton!.center.y - 15))
        hourLine.path = linePath.CGPath
        hourLine.fillColor = nil
        hourLine.opacity = 1.0
        hourLine.strokeColor = UIColor.darkGrayColor().CGColor
        
        //draw the minute line
        linePath.moveToPoint(completedButton!.center)
        linePath.addLineToPoint(CGPointMake(completedButton!.center.x - 18, completedButton!.center.y))
        minuteLine.path = linePath.CGPath
        minuteLine.fillColor = nil
        minuteLine.opacity = 1.0
        minuteLine.strokeColor = UIColor.darkGrayColor().CGColor
        
        self.view.layer.addSublayer(circle)
        self.view.layer.addSublayer(hourLine)
        self.view.layer.addSublayer(minuteLine)

    }
    
    func setupNavBar() {
        
        //nav bar setup
        self.navigationController.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController.navigationBar.barStyle = UIBarStyle.BlackTranslucent
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
        
//        var gearButton = UIBarButtonItem(title: "\u{2699} ", style: UIBarButtonItemStyle.Plain, target: self, action: "settings")
        var gearImage = UIImage(named: "gear.png")
        var gearButton = UIBarButtonItem(image: gearImage, style: .Plain, target: self, action: "settings")
//        var gearButton = UIBarButtonItem(title: "\u{2699} ", style: UIBarButtonItemStyle.Plain, target: self, action: "settings")
        self.navigationItem.rightBarButtonItem = gearButton;
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        //reset the button size
        self.composeButtonView!.bounds = origComposeRect!
    }
    
    // ==========================================
    // MARK: action methods
    // ==========================================

    @IBAction func composeBrief(sender: AnyObject) {
        
        //prevent duplicate tap
        composeButton.enabled = false
        completedButton.enabled = false
        
        UIView.animateWithDuration(0.3, animations: {
            
            var rect = self.composeButtonView!.frame
            rect.size.height += 15
            rect.size.width += 15
            
            self.composeButtonView!.bounds = rect
            
            }, completion: {
                (value: Bool) in
                self.cvc = ComposeViewController(nibName: nil, bundle: nil)
                self.navigationController.pushViewController(self.cvc, animated: true)
                self.composeButton.enabled = true
                self.completedButton.enabled = true
            })
    }
    
    @IBAction func showCompletedBriefs(sender: AnyObject) {
        
        //prevent duplicate tap
        composeButton.enabled = false
        completedButton.enabled = false
        
        CATransaction.begin()
        var planet = CALayer()
        
        CATransaction.setCompletionBlock({
            var cbvc = CompletedBriefViewController(nibName: nil, bundle: nil)
            self.navigationController.pushViewController(cbvc, animated: true)
            planet.removeFromSuperlayer()
            self.composeButton.enabled = true
            self.completedButton.enabled = true
            })
        
        planet.bounds = CGRectMake(0, 0, 7, 7);
        planet.position = CGPointMake(self.completedButton.bounds.width / 2, 0);
        planet.cornerRadius = 5;
        planet.backgroundColor = UIColor.redColor().CGColor
        self.circle.addSublayer(planet)
        
        var anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        anim.fromValue = 0
        anim.toValue = (360 * M_PI) / 180
        anim.repeatCount = 1
        anim.duration = 0.3
        
        self.circle.addAnimation(anim, forKey: "transform")
        CATransaction.commit()
    }
    
    func settings() {
        println("settings")
    }
    
}

