//
//  ComposeBriefTableViewCell.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/24/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class ComposeBriefTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        cellLabel.numberOfLines = 5
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
}
