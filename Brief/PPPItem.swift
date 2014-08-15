//
//  PPPEntity.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/15/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import Foundation


class PPPItem: NSObject, NSCoding {
    
    private var id: NSUUID
    private var content: String
    private var flag: Flag
    var comments = Array<Comment>()
        
    init(content: String) {
        self.id = NSUUID.UUID()
        self.content = content
        self.flag = Flag()
    }
    
    func getId() -> NSUUID {
        return self.id
    }
    
    func setContent(content: String) {
        self.content = content
    }
    
    func getContent() -> String {
        return self.content
    }
    
    func isFlagged() -> Bool {
        
        return flag.isFlagged()
        
    }
    
    func flag(flag: Bool) {
        self.flag.setFlag(flag)
    }
    
    func addComment(comment: Comment) {
        
        self.comments.append(comment)
    }
    
    func removeComment(comment: Comment) {
        
        var index = find(self.comments, comment)
        
    }
    
    func commentsCount() -> Int {
        return self.comments.count
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        
        aCoder.encodeObject(self.id, forKey: "id")
        aCoder.encodeObject(self.content, forKey: "content")
        aCoder.encodeObject(self.flag, forKey: "flag")
        aCoder.encodeObject(self.comments, forKey: "comments")
        
    }
    
    required init(coder aDecoder: NSCoder!) {
        
        self.id = aDecoder.decodeObjectForKey("id") as NSUUID
        self.content = aDecoder.decodeObjectForKey("content") as String
        self.flag = aDecoder.decodeObjectForKey("flag") as Flag
        self.comments = aDecoder.decodeObjectForKey("comments") as Array<Comment>

    }
    
}