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
    var comments = Array<Comment>()
        
    init(content: String) {
        self.id = NSUUID.UUID().UUIDString
        self.content = content
        self.flagged = false
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
        
        self.comments.append(comment)
    }
    
    func removeComment(comment: Comment) {
        var index = find(self.comments, comment)
    }
    
    func commentsCount() -> Int {
        return self.comments.count
    }
    
}