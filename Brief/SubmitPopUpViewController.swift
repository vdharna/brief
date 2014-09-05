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
    @IBOutlet weak var commentText: UITextView!
    
    let collectionViewCellName = "TeamMemberCollectionViewCell"
    
    var vc: ComposeViewController?
    
    var desiredPoint: CGPoint?
    
    var selectedCell: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.layer.cornerRadius = 10.0
        self.view.layer.shadowColor = UIColor.blackColor().CGColor
        self.view.layer.shadowOffset = CGSizeMake(0, 0)
        self.view.layer.shadowRadius = 10
        self.view.layer.shadowOpacity = 0.5
        
        self.commentText.layer.cornerRadius = 3.0
        
        // load the custom cell via NIB
        var nib = UINib(nibName: collectionViewCellName, bundle: nil)
        
        // Register this NIB, which contains the cell
        self.collectionView.registerNib(UINib(nibName: collectionViewCellName, bundle: nil), forCellWithReuseIdentifier: collectionViewCellName)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsMultipleSelection = false
        
        desiredPoint = CGRectNull.origin
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func send(sender: AnyObject) {
        
        var recipients = self.collectionView.indexPathsForSelectedItems()
        println(recipients)
        
        user.submitBrief({ completed in
            println("")
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: {
                println("")
                self.vc?.animateSubmit()

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
        return CGSizeMake(80, 100)
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        var cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(collectionViewCellName, forIndexPath: indexPath) as TeamMemberCollectionViewCell
        
        if (indexPath == self.selectedCell) {
            cell.selectedIndicator.hidden = false
            cell.teamMemberNameLabel.backgroundColor = UIColor.blackColor()
        } else {
            cell.selectedIndicator.hidden = true
            cell.teamMemberNameLabel.backgroundColor = UIColor.lightGrayColor()
        }
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        var cell = self.collectionView.cellForItemAtIndexPath(indexPath) as TeamMemberCollectionViewCell
        cell.selectedIndicator.hidden = false
        cell.teamMemberNameLabel.backgroundColor = UIColor.blackColor()
        
        if let index = self.selectedCell {
            if let cell = self.collectionView.cellForItemAtIndexPath(index) as? TeamMemberCollectionViewCell {
                cell.selectedIndicator.hidden = true
                cell.teamMemberNameLabel.backgroundColor = UIColor.lightGrayColor()
            }
        }
        
        self.selectedCell = indexPath
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView!) {
        
        if (CGPointEqualToPoint(desiredPoint!, CGRectNull.origin)) {
            return
        }
        
        var rect = scrollView.bounds
        rect.origin = desiredPoint!
        self.collectionView.scrollRectToVisible(rect, animated: true)
        
        desiredPoint = CGRectNull.origin;
    }
    

}
