//
//  SubmitPopUpViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 9/1/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit
import QuartzCore

class SubmitPopUpViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var vc: ComposeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.layer.cornerRadius = 10.0
        self.view.layer.shadowColor = UIColor.blackColor().CGColor
        self.view.layer.shadowOffset = CGSizeMake(0, 0)
        self.view.layer.shadowRadius = 10
        self.view.layer.shadowOpacity = 0.5
        
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerClass(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func send(sender: AnyObject) {
        
        user.submitBrief({ completed in
            println("")
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: {
                println("")
                self.vc?.table.reloadData()

            })
        })
    }
    
    
    @IBAction func cancel(sender: AnyObject) {
        
        self.presentingViewController?.dismissViewControllerAnimated(true, nil)
        
    }
    

    
    // MARK: --------------------------------
    // MARK: CollectionView Delegate Methods
    // MARK: --------------------------------

    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        return CGSizeMake(80, 80)
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        var cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell
        cell.backgroundColor = UIColor.orangeColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        println(indexPath)
    }
}
