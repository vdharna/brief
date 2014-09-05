//
//  TeamMemberCollectionViewCell.swift
//  Brief
//
//  Created by Dharminder Dharna on 9/4/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class TeamMemberCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var teamMemberImageView: UIView!
    @IBOutlet weak var teamMemberNameLabel: UILabel!
    @IBOutlet weak var selectedIndicator: UIView!
    
    var teamMember: TeamMember?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
