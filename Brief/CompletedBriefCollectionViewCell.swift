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
    
    var briefId: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func applySelectedColorScheme() {
        self.dateLabel.backgroundColor = UIColor(red: 255/255, green: 99/255, blue: 71/255, alpha: 1.0)
        self.dateLabel.textColor = UIColor.blackColor()
    }
    
    func applyUnselectedColorScheme() {
        self.dateLabel.backgroundColor = UIColor(red: 202/255, green: 202/255, blue: 202/255, alpha: 1.0)
        self.dateLabel.textColor = UIColor.whiteColor()
    }

}
