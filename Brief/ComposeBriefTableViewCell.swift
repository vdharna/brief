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
    
    let redCellImage = UIImage(named: "compose-table-cell-red.png")
    let greenCellImage = UIImage(named: "compose-table-cell-green.png")
    
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
        self.selectionStyle = UITableViewCellSelectionStyle.None
        if (self.cellLabel.text.utf16Count > 140) {
            self.cellImage.image = redCellImage
        } else {
            self.cellImage.image = greenCellImage
            
        }
    }
    
}
