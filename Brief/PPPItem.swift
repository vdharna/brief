//
//  PPPEntity.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/15/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import Foundation


class PPPItem {
    
    var id: String
    var content: String
    var flagged: Bool
    var containsComments: Bool
    var comments = Array<Comment>()
    
    private var cloudManager = BriefCloudManager()
        
    init(content: String) {
        self.id = NSUUID.UUID().UUIDString
        self.content = content
        self.flagged = false
        self.containsComments = false
    }
    
    func getId() -> String {
        return self.id
    }
    
    func setContent(content: String) {
        self.content = content
    }
    
    func getContent() -> String {
        return self.content
    }
    
    func isFlagged() -> Bool {
        return flagged
    }
    
    func setFlag(flag: Bool) {
        self.flagged = flag
    }
    
    func addComment(comment: Comment) {
        self.containsComments = true
        self.comments.append(comment)
    }
    
    func hasComments() -> Bool {
        return self.containsComments
    }
    
    func commentsCount() -> Int {
        return self.comments.count
    }
    
    func loadCommentsFromiCloud(completionClosure: ((Bool) -> Void)) {
        
        self.cloudManager.queryForCommmentsWithReferenceNamed(self.id, completionClosure: { records in
            
            self.comments.removeAll(keepCapacity: true)
            
            for i in (0 ..< records.count) {
                var id = records[i].recordID.recordName
                var content = records[i].objectForKey("content") as String
                var createdBy = records[i].objectForKey("createdBy") as String
                var createdDate = records[i].objectForKey("createdDate") as NSDate
                
                var comment = Comment(content: content)
                comment.id = id
                comment.createdBy = createdBy
                comment.createdDate = createdDate
                
                self.addComment(comment)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                completionClosure(true)
            })
            
            
        })
    }
    
}