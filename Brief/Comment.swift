//
//  Comment.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/27/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import Foundation

func ==(lhs: Comment, rhs: Comment) -> Bool {
    return lhs.getId() == rhs.getId()
}

class Comment: Equatable {
    
    private var id: Int
    private var content: String
    private var createdDate: NSDate
    private var createdBy: TeamMember
    
    init(content: String, createdDate: NSDate, createdBy: TeamMember) {
        self.id = NSUUID.UUID().hash
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
    
    func getId() -> Int {
        return self.id
    }
    
    func getContent() -> String {
        return self.content
    }
    
    
}
