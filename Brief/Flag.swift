//
//  Flag.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/28/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import Foundation

class Flag {
    
    private var flagged: Bool
    
    init() {
        self.flagged = false
    }
    
    func isFlagged() -> Bool {
        return flagged
    }
    
    func setFlag(flag: Bool) {
        self.flagged = flag
    }
    
}
