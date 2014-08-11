//
//  MasterCompletedBriefViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 8/11/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class MasterCompletedBriefViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let cellName = "CompletedBriefCollectionViewCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        "CustomCollectionViewCell"
        
        
        // load the custom cell via NIB
        var nib = UINib(nibName: cellName, bundle: nil)
        
        // Register this NIB, which contains the cell
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: cellName)
        
        var cvfl = UICollectionViewFlowLayout()
        cvfl.scrollDirection = UICollectionViewScrollDirection.Horizontal
        cvfl.minimumInteritemSpacing = 0
        cvfl.minimumLineSpacing = 1
        
        self.collectionView.setCollectionViewLayout(cvfl, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return user.getCompletedBriefs().count
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellName, forIndexPath: indexPath) as CompletedBriefCollectionViewCell
        
        var brief = user.getCompletedBriefs()[indexPath.row]
        cell.tag = brief.getId()

        var df = NSDateFormatter()
        
        df.dateFormat = "dd"
        var myDayString = df.stringFromDate(brief.submittedDate)
        
        df.dateFormat = "MMM"
        var myMonthString = df.stringFromDate(brief.submittedDate)
        
        df.dateFormat = "yy"
        var myYearString = df.stringFromDate(brief.submittedDate)
        
        cell.dateLabel.text = "\(myMonthString) \(myDayString)"

        return cell
    }
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        println("\(indexPath)")
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        return CGSizeMake(70, 25)
    }

}
