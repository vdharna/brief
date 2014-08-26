//
//  CompletedBriefCell.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/23/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class CompletedBriefTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    
    var itemID: String!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Configure the view for the selected state

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.cellLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        if (self.itemID.isEmpty) { // put a placeholder cell in it's place to avoid an akward looking cell
            
            self.cellLabel.textColor = UIColor.lightGrayColor()
            self.accessoryType = UITableViewCellAccessoryType.None
            self.userInteractionEnabled = false
            
        } else {
            
            self.cellLabel.textColor = UIColor.darkTextColor()
            self.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            self.userInteractionEnabled = true
            
        }

    }
    
}
