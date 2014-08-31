//
//  ComposeItemTableViewCell.swift
//  Brief
//
//  Created by Dharminder Dharna on 8/30/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class ComposeItemTableViewCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    var briefId: String!
    
    var line: UIView?
    var circle: UIView?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.line?.removeFromSuperview()
        self.circle?.removeFromSuperview()
        
        // Configure the view for the selected state
        cellLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        line = UIView(frame: CGRect(x: 12, y: 0, width: 2, height: self.frame.height))
        let position = (line!.frame.height - 20) / 2
        circle = UIView(frame: CGRect(x:3, y: position, width:22, height:22))
        
        circle!.backgroundColor = UIColor.whiteColor()
        circle!.layer.borderWidth = 2
        circle!.clipsToBounds = true
        circle!.layer.cornerRadius = circle!.frame.size.width / 2
        
        var imageView = UIImageView(frame: CGRectMake(2.5, 2.5, 17, 17))
        var image = UIImage(named: "icon.png")
        imageView.image = image
        circle!.addSubview(imageView)
        
        if (self.cellLabel.text.utf16Count > characterLimit) {
            line!.backgroundColor = UIColor(red: 153/255, green: 0, blue: 0, alpha: 1)
            circle!.layer.borderColor = UIColor(red: 153/255, green: 0, blue: 0, alpha: 1).CGColor

        } else {
            line!.backgroundColor = UIColor(red: 0, green: 153/255, blue: 76/255, alpha: 1)
            circle!.layer.borderColor = UIColor(red: 0, green: 153/255, blue: 76/255, alpha: 1).CGColor
            
        }
        addSubview(line!)
        addSubview(circle!)
       
    }
    
}
