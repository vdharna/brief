//
//  BriefCloudManager.swift
//  Brief
//
//  Created by Dharminder Dharna on 8/18/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import Foundation
import CloudKit

class BriefCloudManager {
    
    var container: CKContainer
    var publicDatabase: CKDatabase
    
    init() {
        
        self.container = CKContainer.defaultContainer()
        self.publicDatabase = container.publicCloudDatabase
    }
    
    func requestDiscoverabilityPermission(completionClosure: ((Bool) -> Void)) {
        
        self.container.requestApplicationPermission(CKApplicationPermissions.PermissionUserDiscoverability, completionHandler: {applicationPermissionStatus, error in
            
            if (error != nil) {
                
                println("\(error)")
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), {
                    completionClosure(applicationPermissionStatus == CKApplicationPermissionStatus.Granted)
                    
                })
                
            }
            
        })
        
    }
    
    func discoverUserInfo(completionClosure: (userInfo :CKDiscoveredUserInfo) ->()) {
        
        self.container.fetchUserRecordIDWithCompletionHandler({recordID, error in
            if (error != nil) {
                println("\(error)")
            } else {
                self.container.discoverUserInfoWithUserRecordID(recordID, completionHandler: {user, error in
                    if (error != nil) {
                        println("\(error)")
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            completionClosure(userInfo: user)
                        })
                    }
                })
            }
        })
    }
    
    func fetchRecordWithID(recordID: String, completionClosure: (record :CKRecord) ->()) {
    
        var current = CKRecordID(recordName: recordID)
        self.publicDatabase.fetchRecordWithID(current, completionHandler: { record, error in
            
            if (error != nil) {
                
                println("An error occured: \(error)")
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), {
                    completionClosure(record: record)
                    
                })
                
            }
        })
    }
    
    func saveRecord(record: CKRecord) {
        
        self.publicDatabase.saveRecord(record, completionHandler: { record, error in
            
            if (error != nil) {
                
                println("An error occured saving record: \(error)")
                
            } else {
                
                println("Successfully saved record")
                
            }
        })
    }
    
    func deleteRecord(record: CKRecord) {
        
        self.publicDatabase.deleteRecordWithID(record.recordID, completionHandler: { recordID, error in
            
            if (error != nil) {
                
                println("An error occured saving record: \(error)")
                
            } else {
                
                println("Successfully deleted record")
                
            }
        })
        
    }

    func addBriefRecord(brief: Brief, completionClosure: (record :CKRecord) ->()) {
        
        var record: CKRecord = CKRecord(recordType: "Brief")
        
        self.publicDatabase.saveRecord(record, completionHandler: { record, error in
            
            if (error != nil) {
                
                println("An error occured saving record: \(error)")
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), {
                    completionClosure(record: record)
                })
                
            }
            
        })
        
    }
    
    func addProgressRecord(progress: Progress, completionClosure: (record :CKRecord) ->()) {
        
        var record: CKRecord = CKRecord(recordType: "Progress")
        record.setObject(progress.content, forKey: "content")
        
        self.publicDatabase.saveRecord(record, completionHandler: { record, error in
            
            if (error != nil) {
                
                println("An error occured saving record: \(error)")
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), {
                    completionClosure(record: record)
                })
                
            }
            
        })
        
    }
    
    func addPlanRecord(plan: Plan, completionClosure: (record :CKRecord) ->()) {
        
        var record: CKRecord = CKRecord(recordType: "Plan")
        record.setObject(plan.content, forKey: "content")

        self.publicDatabase.saveRecord(record, completionHandler: { record, error in
            
            if (error != nil) {
                
                println("An error occured saving record: \(error)")
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), {
                    completionClosure(record: record)
                })
                
            }
            
        })
        
    }
    
    func addProblemRecord(problem: Problem, completionClosure: (record :CKRecord) ->()) {
        
        var record: CKRecord = CKRecord(recordType: "Problem")
        record.setObject(problem.content, forKey: "content")

        self.publicDatabase.saveRecord(record, completionHandler: { record, error in
            
            if (error != nil) {
                
                println("An error occured saving record: \(error)")
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), {
                    completionClosure(record: record)
                })
                
            }
            
        })
        
    }
    
    func addCommentRecord(comment: Comment, completionClosure: (record :CKRecord) ->()) {
        
        var record: CKRecord = CKRecord(recordType: "Plan")
        
        self.publicDatabase.saveRecord(record, completionHandler: { record, error in
            
            if (error != nil) {
                
                println("An error occured saving record: \(error)")
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), {
                    completionClosure(record: record)
                })
                
            }
            
        })
        
    }

}
