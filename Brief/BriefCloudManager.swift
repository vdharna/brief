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
                dispatch_async(dispatch_get_main_queue(), {
                    completionClosure(applicationPermissionStatus == CKApplicationPermissionStatus.Granted)
                    
                })
                
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
    
    func discoverUserInfoWithRecordID(recordID: CKRecordID, completionClosure: (userInfo :CKDiscoveredUserInfo) ->()) {
        
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

    func addBriefRecord(draftBrief: Brief, completionClosure: (record :CKRecord) ->()) {
    
        var record: CKRecord = CKRecord(recordType: "Brief", recordID: CKRecordID(recordName: draftBrief.id))
        // update the draft brief status
        record.setObject(draftBrief.status.toRaw(), forKey: "status")
        
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
        
        // create the record
        var record: CKRecord = CKRecord(recordType: "Progress", recordID: CKRecordID(recordName: progress.id))

        //set the common traits
        self.setPPPCommonTraits(progress, record: record)
        
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
        
        var record: CKRecord = CKRecord(recordType: "Plan", recordID: CKRecordID(recordName: plan.id))

        //set the common traits
        self.setPPPCommonTraits(plan, record: record)

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
        
        var record: CKRecord = CKRecord(recordType: "Problem", recordID: CKRecordID(recordName: problem.id))

        //set the common traits
        self.setPPPCommonTraits(problem, record: record)

        self.publicDatabase.saveRecord(record, completionHandler: { record, error in
            println("\(record)")
            if (error != nil) {
                
                println("An error occured saving record: \(error)")
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), {
                    completionClosure(record: record)
                })
                
            }
            
        })
        
    }
    
    private func setPPPCommonTraits(item: PPPItem, record: CKRecord) {
        
        // add the content
        record.setObject(item.content, forKey: "content")
        // add the flag info
        
        // add notification flag
        
        // add a reference to the Brief (back reference)
        var briefRecordID = CKRecordID(recordName: user.getDraftBrief().id)
        var reference = CKReference(recordID: briefRecordID, action: .DeleteSelf)
        record.setObject(reference, forKey: "brief")

    }
    
    func addCommentRecord(comment: Comment, item: PPPItem, completionClosure: (record :CKRecord) ->()) {
        
        // create the record instance
        var record: CKRecord = CKRecord(recordType: "Comment")
        // add the content
        record.setObject(comment.content, forKey: "content")
        // add the user
        record.setObject(user.getFirstName(), forKey: "createdBy")
        // add the created date since it's not working in iCloud
        record.setObject(NSDate(), forKey: "createdDate")
        // add the reference
        var itemRecordID = CKRecordID(recordName: item.id)
        var reference = CKReference(recordID: itemRecordID, action: .DeleteSelf)
        record.setObject(reference, forKey: "item")
        
        // save the comment record
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
    
    func queryForDraftBrief(completionClosure: (records: Array<CKRecord>) ->()) {
        
        // Match draft brief record whose owner (TeamMember) field points to the specified draft brief record.
        var recordToMatch = user.userInfo?.userRecordID
        var predicate = NSPredicate(format: "(status == %@) AND (creatorUserRecordID == %@)", NSNumber(int: 1), recordToMatch!)

        // Create the query object.
        var query = CKQuery(recordType:"Brief", predicate: predicate)

        publicDatabase.performQuery(query, inZoneWithID: nil, completionHandler: {results, error in
                        
            if (error != nil) {
                println("An error occured retrieving records: \(error)")
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), {
                    completionClosure(records: results as Array<CKRecord>)
                    
                })
                
            }
            
        });

    }
    
    func queryForCompletedBriefs(completionClosure: (records: Array<CKRecord>) ->()) {
        
        // Match draft brief record whose owner (TeamMember) field points to the specified draft brief record.
        var recordToMatch = user.userInfo?.userRecordID
        var predicate = NSPredicate(format: "(status == %@) AND (creatorUserRecordID == %@)", NSNumber(int: 2), recordToMatch!)
        
        // Create the query object.
        var query = CKQuery(recordType:"Brief", predicate: predicate)

        publicDatabase.performQuery(query, inZoneWithID: nil, completionHandler: {results, error in
            
            if (error != nil) {
                println("An error occured retrieving records: \(error)")
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), {
                    completionClosure(records: results as Array<CKRecord>)
                    
                })
                
            }
            
        });
        
    }
    
    func queryForItemRecordsWithReferenceNamed(referenceRecordName: String, recordType: String, completionClosure: (records: Array<CKRecord>) ->()) {
    
        var recordID = CKRecordID(recordName: referenceRecordName)
        var parent = CKReference(recordID: recordID, action: CKReferenceAction.None)
        
        var predicate = NSPredicate(format: "brief == %@", parent)
        var query = CKQuery(recordType: recordType, predicate: predicate)
        
        var queryOperation = CKQueryOperation(query: query)
        
        var results = Array<CKRecord>()
        
        queryOperation.recordFetchedBlock = {record in
            results.append(record)
        }
        
        queryOperation.queryCompletionBlock = { cursor, error in
         
            if (error != nil) {
                println("An error occured retrieving records: \(error)")
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    completionClosure(records: results)
                })
            }
        }
        
        self.publicDatabase.addOperation(queryOperation)
        
    }

}
