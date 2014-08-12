//
//  CustomCollectionViewCell.swift
//  Brief
//
//  Created by Dharminder Dharna on 8/11/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class CompletedBriefCollectionViewCell: UICollectionViewCell {

    @IBOutlet
    weak var monthLabel: UILabel!
    
    @IBOutlet
    weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func applySelectedColorScheme() {
        self.dateLabel.backgroundColor = UIColor.redColor()
        self.dateLabel.textColor = UIColor.blackColor()
    }
    
    func applyUnselectedColorScheme() {
        self.dateLabel.backgroundColor = UIColor(red: 0.192, green: 0.192, blue: 0.192, alpha: 0.08)
        self.dateLabel.textColor = UIColor.grayColor()
    }

}
