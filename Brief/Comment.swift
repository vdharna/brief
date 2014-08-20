//
//  Comment.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/27/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import Foundation

func ==(lhs: Comment, rhs: Comment) -> Bool {
    return lhs.id == rhs.id
}

class Comment: Equatable {
    
    var id: String
    var content: String
    var createdDate: NSDate?
    var createdBy: String? // first and last name of the commentor
    
    init(content: String) {
        self.id = NSUUID.UUID().UUIDString
        self.content = content

    }
    
    func getElapsedTime() -> String {
        
        var timeInterval = createdDate?.timeIntervalSinceNow
        var timeIntervalSeconds = timeInterval! / 1000
        
//        if (timeIntervalSeconds < 6000) {
//            // return the number of hours
//            return timeIntervalSeconds /
//        }
        
        return "1"
        
    }
    
    
}
