//
//  CompletedBriefCell.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/23/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class CompletedBriefCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    
    init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        cellLabel.numberOfLines = 5
    }
    
    
}
