//
//  AddBriefView.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/18/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class CompletedBriefButtonView: UIView {
    
    let lineWidth: CGFloat = 2

    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        self.backgroundColor = UIColor.clearColor()
        self.userInteractionEnabled = false
    }

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        // Drawing code
        var bounds = self.bounds
        
        // Figure out the center of the bounds rectangle
        var center = CGPointMake(bounds.origin.x + bounds.size.width / 2.0, bounds.origin.y + bounds.size.height / 2.0)
        
        // The circle will be the largest that will fit in the view
        var radius = (min(bounds.size.width, bounds.size.height) / 2.0)
   
        var path = UIBezierPath()
        
        // Add an arc to the path at center, with radius of radius,
        // from 0 to 2*PI radians (a circle)
        //path.addArcWithCenter(center, radius: radius - lineWidth, startAngle: 0.0, endAngle: M_PI * 2.0, clockwise: true)
        
        //draw the hour hand line at 12 o'clock
        path.moveToPoint(center)
        path.addLineToPoint(CGPointMake(center.x, center.y - 25))
        
        //draw the second-hand line at 45
        path.moveToPoint(center)
        path.addLineToPoint(CGPointMake(center.x - 28, center.y))
        
        path.lineWidth = lineWidth
        UIColor.darkGrayColor().setStroke()
       
        path.stroke()
        
    }
    
    

}
