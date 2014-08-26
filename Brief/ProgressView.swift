//
//  ProgressView.swift
//  Brief
//
//  Created by Dharminder Dharna on 8/25/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        var hudView = UIView(frame: CGRectMake(75, 155, 170, 170))
        hudView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        hudView.clipsToBounds = true
        hudView.layer.cornerRadius = 10.0
        
        var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activityIndicatorView.frame = CGRectMake(65, 40, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height)
        
        hudView.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        var captionLabel = UILabel(frame: CGRectMake(20, 115, 130, 22))
        captionLabel.backgroundColor = UIColor.clearColor()
        captionLabel.textColor = UIColor.whiteColor()
        captionLabel.adjustsFontSizeToFitWidth = true
        captionLabel.textAlignment = NSTextAlignment.Center
        captionLabel.text = "Loading..."
        
        hudView.addSubview(captionLabel)
        
        self.addSubview(hudView)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

}
