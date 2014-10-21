//
//  Comment.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/27/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

func ==(lhs: Comment, rhs: Comment) -> Bool {
    return lhs.id == rhs.id
}

let CommentContentField = "content" // String
let ItemReferenceRecordType = "item" //Reference
let CreatedByField = "creatorUserRecordID" // String
let CreatedDateField = "creationDate" //Date --> Sort By

let CommentRecordType = "Comment"

var cloudManager = BriefCloudManager()

class Comment: Equatable {
    
    var id: String
    var content: String
    var createdDate: NSDate!
    var createdBy: String! // first and last name of the commentor
    var image: UIImage?
    
    var userReferenceID: CKRecordID! // used to lookup the user reference
    
    init(content: String) {
        self.id = NSUUID().UUIDString
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
    
    func loadUserInfo(completionClosure: ((Bool) -> Void)) {
        
        cloudManager.fetchRecordWithID(userReferenceID.recordName, completionClosure: { record in
            if let preferredName = record.objectForKey("preferredName") as? String {
                if (!preferredName.isEmpty) {
                    self.createdBy = preferredName
                }
            } else {
                
                cloudManager.discoverUserInfoWithRecordID(self.userReferenceID, completionClosure: { userInfo in
                    self.createdBy = userInfo.firstName + " " + userInfo.lastName
                })
            }
            
            
            if let photoAsset = record.objectForKey("photo") as? CKAsset {
                var image = UIImage(contentsOfFile: photoAsset.fileURL.path!)
                self.image = image
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                completionClosure(true)
            })
        })
        
    }
    
}
