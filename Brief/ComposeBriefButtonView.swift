//
//  AddBriefView.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/19/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class ComposeBriefButtonView: UIView {

    let lineWidth: CGFloat = 1
    
    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        self.backgroundColor = UIColor.clearColor()
        self.userInteractionEnabled = false
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        // Drawing code
        let bounds = self.bounds
        
        // Figure out the center of the bounds rectangle
        let verticalCenter = CGPointMake(bounds.origin.x + bounds.size.width / 2.0, 0)
        let horizontalCenter = CGPointMake(0, bounds.origin.y + bounds.size.height / 2.0)
        
        let path = UIBezierPath()
        
        //draw the vertical line
        path.moveToPoint(verticalCenter)
        path.addLineToPoint(CGPointMake(bounds.origin.x + bounds.size.width / 2.0, bounds.size.height))
        
        //draw the horizontal
        path.moveToPoint(horizontalCenter)
        path.addLineToPoint(CGPointMake(bounds.size.width, bounds.origin.x + bounds.size.width / 2.0))
        
        path.lineWidth = lineWidth
        UIColor.darkGrayColor().setStroke()
        
        path.stroke()
        
    }

}
