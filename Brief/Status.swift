//
//  Status.swift
//  Brief
//
//  Created by Dharminder Dharna on 8/14/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import Foundation

enum Status: Int {
    
    case InProgress = 1
    case IsCompleted = 2
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .InProgress:
            return "In Progress"
        case .IsCompleted:
            return "Completed"
        default:
            return String(self.toRaw())
            
        }
    }
}