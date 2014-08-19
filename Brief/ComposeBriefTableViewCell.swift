//
//  ComposeBriefTableViewCell.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/24/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class ComposeBriefTableViewCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    var briefId: String!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        cellLabel.numberOfLines = 7
        cellLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)

    }
    
}
