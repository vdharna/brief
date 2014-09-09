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
    
    func uploadAssetWithURL(assetURL: NSURL, completionHandler: (record: CKRecord) ->()) {
        
        //find the user record
        if let userRecordID = user.userInfo?.userRecordID.recordName? {
            self.fetchRecordWithID(userRecordID, completionClosure: { (record: CKRecord) in
                
                var assetRecord = CKAsset(fileURL: assetURL)
                record.setObject(assetRecord, forKey: "photo")
                
                self.publicDatabase.saveRecord(record, completionHandler: { record, error in
                    
                    if (error != nil) {
                        println(error)
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            completionHandler(record: record)
                        })
                    }
                })
                
            })
        }
        
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
    
    func saveRecord(record: CKRecord, completionClosure: ((Bool) -> Void)) {
        
        self.publicDatabase.saveRecord(record, completionHandler: { record, error in
            
            if (error != nil) {
                println("An error occured saving record: \(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    completionClosure(false)
                })
            } else {
                println("Successfully saved record")
                dispatch_async(dispatch_get_main_queue(), {
                    completionClosure(true)
                })
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
    
        var record: CKRecord = CKRecord(recordType: BriefRecordType, recordID: CKRecordID(recordName: draftBrief.id))
        // update the draft brief status
        record.setObject(draftBrief.status.toRaw(), forKey: StatusField)
        
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
        var record: CKRecord = CKRecord(recordType: ProgressRecordType, recordID: CKRecordID(recordName: progress.id))

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
        
        var record: CKRecord = CKRecord(recordType: PlanRecordType, recordID: CKRecordID(recordName: plan.id))

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
        
        var record: CKRecord = CKRecord(recordType: ProblemRecordType, recordID: CKRecordID(recordName: problem.id))

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
        record.setObject(item.content, forKey: ItemContentField)
        // add the flag info
        record.setObject(item.isFlagged(), forKey: FlagField)
        // add notification flag
        
        // add comment boolean flag
        record.setObject(item.hasComments(), forKey: HasCommentsField)
        
        // add a reference to the Brief (back reference)
        var briefRecordID = CKRecordID(recordName: user.getDraftBrief().id)
        var reference = CKReference(recordID: briefRecordID, action: .DeleteSelf)
        record.setObject(reference, forKey: BriefReferenceRecordType)

    }
    
    func addCommentRecord(comment: Comment, item: PPPItem, completionClosure: (record :CKRecord) ->()) {
        
        // create the record instance
        var record: CKRecord = CKRecord(recordType: CommentRecordType)
        // add the content
        record.setObject(comment.content, forKey: CommentContentField)
        // add the user
        record.setObject(user.getFirstName(), forKey: CreatedByField)
        // add the reference
        var itemRecordID = CKRecordID(recordName: item.id)
        var reference = CKReference(recordID: itemRecordID, action: .DeleteSelf)
        record.setObject(reference, forKey: ItemReferenceRecordType)
        
        // save the comment record
        self.publicDatabase.saveRecord(record, completionHandler: { record, error in
            
            if (error != nil) {
                
                println("An error occured saving record: \(error)")
                
            } else {
                
                // update the boolean for the item since it now has a comment
                self.fetchRecordWithID(item.getId(), completionClosure: { record in
                    
                    record.setObject(item.hasComments(), forKey: HasCommentsField)
                    
                    self.saveRecord(record, completionClosure: { completed in
                    
                        dispatch_async(dispatch_get_main_queue(), {
                            completionClosure(record: record)
                    })
                
                })

                })
                
            }
            
        })
        
    }
    
    func queryForDraftBrief(completionClosure: (records: Array<CKRecord>) ->()) {
        
        // Match draft brief record whose owner (TeamMember) field points to the specified draft brief record.
        var recordToMatch = user.userInfo?.userRecordID
        var predicate = NSPredicate(format: "(status == %@) AND (creatorUserRecordID == %@)", NSNumber(int: 1), recordToMatch!)

        // Create the query object.
        var query = CKQuery(recordType:BriefRecordType, predicate: predicate)

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
        var query = CKQuery(recordType:BriefRecordType, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: SubmittedDateField, ascending: false)]

        publicDatabase.performQuery(query, inZoneWithID: nil, completionHandler: {results, error in
            println("\(results.first)")
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
    
    func queryForCommmentsWithReferenceNamed(referenceRecordName: String, completionClosure: (records: Array<CKRecord>) ->()) {
        
        // Match draft brief record whose owner (TeamMember) field points to the specified draft brief record.
        var recordToMatch = CKRecordID(recordName: referenceRecordName)
        var predicate = NSPredicate(format: "(item == %@)", recordToMatch)
        
        // Create the query object.
        var query = CKQuery(recordType: CommentRecordType, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: CreatedDateField, ascending: true)]
        
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
    
    func subscribeForComments(referenceRecord: PPPItem, completionClosure: (subscription: CKSubscription) ->()) {
        
        var recordToMatch = CKRecordID(recordName: referenceRecord.id)
        var predicate = NSPredicate(format: "(item == %@)", recordToMatch)
        
        var itemSubscription = CKSubscription(recordType: CommentRecordType, predicate: predicate, options: CKSubscriptionOptions.FiresOnRecordCreation)
        
        var notification = CKNotificationInfo()
        notification.alertBody = "You recieved a new comment!"
        itemSubscription.notificationInfo = notification
        
        self.publicDatabase.saveSubscription(itemSubscription, completionHandler: { subscription, error in
            
            if (error != nil) {
                println("An error occured in saving subscription \(error)")
            } else {
                println("Subscribed to Comment")

            }
            
            dispatch_async(dispatch_get_main_queue(), {
                completionClosure(subscription: subscription)
            })
        })
        
    }
    
    func unsubscribe(subscriptionID: String) {
        
        var modifyOperation = CKModifySubscriptionsOperation()
        modifyOperation.subscriptionIDsToDelete = [subscriptionID]
        
        modifyOperation.modifySubscriptionsCompletionBlock = { savedSubscriptions, deletedSubscriptionIDs, error in
            if (error != nil) {
                // In your app, handle this error beautifully.
                println("An error occured in operation: \(error)")
            } else {
                println("Unsubscribed to Item")
            }
            
        }
        
        self.publicDatabase.addOperation(modifyOperation)
        
    }

}
