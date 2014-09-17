//
//  PPPEntity.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/15/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

let ItemContentField = "content"
let BriefReferenceRecordType = "brief"
let FlagField = "flag"
let HasCommentsField = "hasComments"

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
        
        self.comments.removeAll(keepCapacity: true)
        
        var recordList: Array<CKRecord>?
        
        self.cloudManager.queryForCommmentsWithReferenceNamed(self.id, completionClosure: { records in
                        
            for record in records {
                
                var id = record.recordID.recordName
                var content = record.objectForKey(CommentContentField) as String
                var createdDate = record.objectForKey(CreatedDateField) as NSDate
                var userReference = record.objectForKey("creatorUserRecordID") as CKRecordID
                
                var comment = Comment(content: content)
                comment.id = id
                comment.createdDate = createdDate
                comment.userReferenceID = userReference
                
                self.addComment(comment)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                completionClosure(true)
            })
                        
        })        

    }
    
    func loadComments(completionClosure: ((Bool) -> Void)) {
        
        self.comments.removeAll(keepCapacity: true)
        
        self.cloudManager.queryForCommmentsWithReferenceNamed(self.id, completionClosure: { records in
            
            var userReferences = Array<CKRecordID>()
            
            for record in records {
                
                var id = record.recordID.recordName
                var content = record.objectForKey(CommentContentField) as String
                var createdDate = record.objectForKey(CreatedDateField) as NSDate
                var userReference = record.objectForKey("creatorUserRecordID") as CKRecordID
                
                var comment = Comment(content: content)
                comment.id = id
                comment.createdDate = createdDate
                comment.userReferenceID = userReference
                
                self.addComment(comment)
                
                userReferences.append(userReference)
            }
            
            // load the user name and photo
            var fetchOperation = CKFetchRecordsOperation(recordIDs: userReferences)
            fetchOperation.fetchRecordsCompletionBlock = { recordsByRecordID, operationError in
                
                for comment in self.comments {
                    
                    var userRecord = recordsByRecordID[comment.userReferenceID] as CKRecord
                    
                    if let preferredName = userRecord.objectForKey("preferredName") as? String {
                        if (!preferredName.isEmpty) {
                            comment.createdBy = preferredName
                        }
                    } else {
                        
                        self.cloudManager.discoverUserInfoWithRecordID(comment.userReferenceID, completionClosure: { userInfo in
                            
                            comment.createdBy = userInfo.firstName + " " + userInfo.lastName
                        })
                    }
                    
                    if let photoAsset = userRecord.objectForKey("photo") as? CKAsset {
                        var image = UIImage(contentsOfFile: photoAsset.fileURL.path!)
                        comment.image = image
                    }
                    
                }
                

                
                dispatch_async(dispatch_get_main_queue(), {
                    completionClosure(true)
                })
            }
            
            self.cloudManager.publicDatabase.addOperation(fetchOperation)
            
        })
        
    }
    
}