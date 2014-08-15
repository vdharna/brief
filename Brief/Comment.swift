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

class Comment: NSObject, NSCoding, Equatable {
    
    private var id: NSUUID
    private var content: String
    private var createdDate: NSDate
    private var createdBy: TeamMember
    
    init(content: String, createdDate: NSDate, createdBy: TeamMember) {
        self.id = NSUUID.UUID()
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
    
    func getId() -> NSUUID {
        return self.id
    }
    
    func getContent() -> String {
        return self.content
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        
        aCoder.encodeObject(self.id, forKey: "id")
        aCoder.encodeObject(self.content, forKey: "content")
        aCoder.encodeObject(self.createdDate, forKey: "createdDate")
        aCoder.encodeObject(self.createdBy, forKey: "createdBy")
    }
    
    required init(coder aDecoder: NSCoder!) {
        
        self.id = aDecoder.decodeObjectForKey("id") as NSUUID
        self.content = aDecoder.decodeObjectForKey("content") as String
        self.createdDate = aDecoder.decodeObjectForKey("createdDate") as NSDate
        self.createdBy = aDecoder.decodeObjectForKey("createdBy") as TeamMember
        
    }
    
}
