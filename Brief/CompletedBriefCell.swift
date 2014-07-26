//
//  CompletedBriefCell.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/23/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

typealias flagActionBlock = () -> ()
typealias commentActionBlock = () -> ()
typealias shareActionBlock = () -> ()

class CompletedBriefTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var flagButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var flagActionClosure: flagActionBlock?
    var commentActionClosure: commentActionBlock?
    var shareActionClosure: shareActionBlock?
    
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

    }
    
    
    @IBAction func flagPressed(sender: AnyObject) {
        if flagActionClosure { flagActionClosure!() }
    }
    
    @IBAction func commentPressed(sender: AnyObject) {
        if commentActionClosure { commentActionClosure!() }
    }
    
    @IBAction func sharePressed(sender: AnyObject) {
        if shareActionClosure { shareActionClosure!() }
    }
    
    
}
