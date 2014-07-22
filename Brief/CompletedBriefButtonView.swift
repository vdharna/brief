//
//  AddBriefView.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/18/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit
import QuartzCore

class CompletedBriefButtonView: UIView {
    
    let lineWidth: CGFloat = 1
    var animate = false

    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        self.backgroundColor = UIColor.clearColor()
        self.userInteractionEnabled = false
    }

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        // Drawing code
        var orbit = CALayer()
        
        orbit.bounds = self.bounds
        orbit.position = self.center;
        orbit.cornerRadius = self.bounds.width / 2
        orbit.borderColor = UIColor.darkGrayColor().CGColor;
        orbit.borderWidth = 1;
        
        if (animate) {
            
            var planet = CALayer()
            planet.bounds = CGRectMake(0, 0, 10, 10);
            planet.position = CGPointMake(self.bounds.width / 2, 0);
            planet.cornerRadius = 5;
            planet.backgroundColor = UIColor.darkGrayColor().CGColor
            orbit.addSublayer(planet)
            
            
            var anim = CABasicAnimation(keyPath: "transform.rotation")
            anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            anim.fromValue = 0
            anim.toValue = (360 * M_PI) / 180
            anim.repeatCount = Float.infinity
            anim.duration = 8.0
            
            orbit.addAnimation(anim, forKey: "transform")
        }
        
        self.layer.addSublayer(orbit)

        var path = UIBezierPath()
        
        //draw the hour hand line at 12 o'clock
        path.moveToPoint(center)
        path.addLineToPoint(CGPointMake(center.x, center.y - 15))
        
        //draw the second-hand line at 45
        path.moveToPoint(center)
        path.addLineToPoint(CGPointMake(center.x - 18, center.y))
        
        path.lineWidth = lineWidth
        UIColor.darkGrayColor().setStroke()
       
        path.stroke()
        
    }

}
