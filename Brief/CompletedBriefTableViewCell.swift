//
//  CompletedBriefCell.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/23/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

typealias flagActionBlock = () -> (Void)
typealias commentActionBlock = () -> (Void)
typealias shareActionBlock = () -> (Void)

class CompletedBriefTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var flagButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var commentsLabel: UILabel!
    
    var flagActionClosure: flagActionBlock?
    var commentActionClosure: commentActionBlock?
    var shareActionClosure: shareActionBlock?
    
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
        cellLabel.numberOfLines = 5
        //self.selectionStyle = UITableViewCellSelectionStyle.Default

    }
    
    
    @IBAction func flagPressed(sender: AnyObject) {
       if (flagActionClosure != nil) { flagActionClosure!() }
    }
    
    @IBAction func commentPressed(sender: AnyObject) {
        if (commentActionClosure != nil) { commentActionClosure!() }
    }
    
    @IBAction func sharePressed(sender: AnyObject) {
        if (shareActionClosure != nil) { shareActionClosure!() }
    }
    
    
}
