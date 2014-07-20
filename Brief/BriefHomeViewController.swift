//
//  FirstViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/8/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class BriefHomeViewController: UIViewController {
    
    var createBriefVC = CreateBriefViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    }

    @IBAction func createNewBrief(sender: AnyObject) {
        
        println("New Brief Called")
        self.navigationController.pushViewController(createBriefVC, animated: true)
        
    }

    @IBAction func showBriefHistory(sender: AnyObject) {
        
        println("History Called")
        
    }
}

