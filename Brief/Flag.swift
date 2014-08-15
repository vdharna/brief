//
//  Flag.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/28/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import Foundation

class Flag: NSObject, NSCoding {
    
    private var flagged: Bool
    
    override init() {
        self.flagged = false
    }
    
    func isFlagged() -> Bool {
        return flagged
    }
    
    func setFlag(flag: Bool) {
        self.flagged = flag
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        
        aCoder.encodeBool(self.flagged, forKey: "flagged")
        
    }
    
    required init(coder aDecoder: NSCoder!) {
        
        self.flagged = aDecoder.decodeBoolForKey("flagged")
        
    }
    
}
