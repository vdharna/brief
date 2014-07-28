//
//  Comment.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/27/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import Foundation

class Comment {
    
    private var id: Int
    private var content: String
    private var createdDate: NSDate
    private var createdBy: TeamMember
    
    init(id: Int, content: String, createdDate: NSDate, createdBy: TeamMember) {
        self.id = id
        self.content = content
        self.createdDate = createdDate
        self.createdBy = createdBy
    }
    
    func getCreatedDate() -> NSDate {
        return self.createdDate
    }
    
    func getCreatedBy() -> TeamMember {
        return self.createdBy
    }
    
}
