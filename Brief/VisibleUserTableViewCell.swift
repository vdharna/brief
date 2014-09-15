//
//  VisibleUserTableViewCell.swift
//  Brief
//
//  Created by Dharminder Dharna on 9/14/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class VisibleUserTableViewCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.profileImage.clipsToBounds = true;
        var radius = self.profileImage.bounds.width / 2.0
        self.profileImage.layer.borderWidth = 2.0;
        self.profileImage.layer.cornerRadius = radius
        self.profileImage.layer.borderColor = UIColor.blackColor().CGColor
    }
    
}
