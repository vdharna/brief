//
//  SecondViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/8/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class CreateBriefViewController: UIViewController {
    
    var descriptionLabel = UILabel(frame: CGRectMake(20, 77, 280, 88))
    
    let progressDescription = "Progress. Employee's accomplishments, finished items and closed tasks for the period ending."
    
    let planDescription = "Plans. Goals and objectives for the next reporting period."
    
    let problemDescription = "Problems. Items that are stuck and can’t be finished. Problems often need help from someone else, not just the employee."
    
    let segmentedControl = UISegmentedControl(items: ["Progress", "Plans", "Problems"])
    
    var selectedSegment = 0 //remember which segment was selected
    
    //MARK Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        segmentedControl.addTarget(self, action: Selector("segmentChanged"), forControlEvents: .ValueChanged)
        segmentedControl.selectedSegmentIndex = selectedSegment //defaults to the first segment
        
        //set the segment in the navigation bar
        segmentedControl.sizeToFit()
        self.navigationItem.titleView = segmentedControl
        //add the + button
        var addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("add"))
        self.navigationItem.rightBarButtonItem = addButton;
        
        // set the attributedString to the label for proper font rendering
        var formattedText = formatDescLabelText(progressDescription, range: 8)
        descriptionLabel.attributedText = formattedText
        
        //use this to align the text to the top
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.sizeToFit()
        
        //add to the subview
        self.view.addSubview(descriptionLabel)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController.navigationBarHidden = false
        segmentedControl.selectedSegmentIndex = selectedSegment //sets to last selected segment
    }
    
    override func viewWillDisappear(animated: Bool)  {
        
    }
    
    //Mark Action Methods
    
    func segmentChanged() {
        
        selectedSegment = segmentedControl.selectedSegmentIndex
        
        switch (selectedSegment) {
            
        case 0:
            descriptionLabel.attributedText = formatDescLabelText(progressDescription, range: 8)
            
        case 1:
            descriptionLabel.attributedText = formatDescLabelText(planDescription, range: 5)
            
        case 2:
            descriptionLabel.attributedText = formatDescLabelText(problemDescription, range: 8)
            
        default:
            descriptionLabel.text = ""
        }
        
    }
    
    func add() {
        println("Add called")
        var bdmvc = AddBriefViewController()
        self.navigationController.presentViewController(bdmvc, animated: true, completion: nil)
    }
    
    func formatDescLabelText(description: String, range: Int) -> NSAttributedString {
        var attributedText = NSMutableAttributedString(string: description)
        attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 14), range: NSMakeRange(0, countElements(description)))
        
        //make keywords Progress or Plans or Problems bold (HelveticaNueue-Bold size 14
        attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Bold", size: 14), range: NSMakeRange(0, range))
        
        return attributedText
    }
}

