//
//  BriefRepository.swift
//  Brief
//
//  Created by Dharminder Dharna on 8/14/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import Foundation
import CloudKit

class BriefRepository {
    
    
    func saveDraftBriefToDevice(brief: Brief) -> Bool {
        
        var path = self.briefArchivePath()
        
        // Returns true on success
        return NSKeyedArchiver.archiveRootObject(brief, toFile: path!)

    }
    
    func loadDraftBriefFromDevice() -> Brief? {
        
        var path = self.briefArchivePath()
        return NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as? Brief
        
    }
    
    func briefArchivePath() -> String? {
        
        // Make sure that the first argument is NSDocumentDirectory and not NSDocumentationDirectory
        var documentDirectories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        // Get the one document directory from that list
        var documentDirectory: NSString? = documentDirectories[0] as? NSString
        
        return documentDirectory?.stringByAppendingPathComponent("briefs.archive")
        
    }
    
    class func saveDraftBrief(brief: Brief) {
        
        //query for the brief object first
        
        var privateDatabase = CKContainer.defaultContainer().privateCloudDatabase
        var briefRecordID = CKRecordID(recordName: brief.getId())
        var briefRecord: CKRecord = CKRecord(recordType: "Brief", recordID: briefRecordID)
        
        //check to see if it exists already
        privateDatabase.fetchRecordWithID(briefRecordID, completionHandler: ({record, error in
            
            if (record != nil) {
                
                briefRecord = record
                
            }
            
            // 1. Persist Progress list
            var progressList = Array<String>()
            for i in (0 ..< brief.progress.count) {
                progressList.append(brief.progress[i].getContent())
            }
            
            briefRecord.setObject(progressList, forKey: "progress")
            
            // 2. Persist Plan list
            var planList = Array<String>()
            for i in (0 ..< brief.plans.count) {
                planList.append(brief.plans[i].getContent())
            }
            
            briefRecord.setObject(planList, forKey: "plans")
            
            // 2. Persist Problem list
            var problemList = Array<String>()
            for i in (0 ..< brief.problems.count) {
                problemList.append(brief.problems[i].getContent())
            }
            
            briefRecord.setObject(problemList, forKey: "problems")
            
            privateDatabase.saveRecord(briefRecord, completionHandler: ({record, error in
                
                println("Brief Record: \(record)")
                
                var teamMemberRef = CKReference(recordID: nil, action: CKReferenceAction.DeleteSelf)
                
                record.setObject(teamMemberRef, forKey: "teamMember")
                
                privateDatabase.saveRecord(record, completionHandler: ({record, error in
                    println("Brief Record: \(record)")
                    
                }));

            }));
            
        }));
        
    }
    
    class func loadDraftBrief() {
        
        var privateDatabase = CKContainer.defaultContainer().privateCloudDatabase
        
        // Match draft brief record whose owner (TeamMember) field points to the specified draft brief record.
        var recordToMatch = CKReference(recordID: nil, action: CKReferenceAction.DeleteSelf)
        var predicate = NSPredicate(format: "teamMember == %@", recordToMatch)

        // Create the query object.
        var query = CKQuery(recordType:"Brief", predicate: predicate)
        privateDatabase.performQuery(query, inZoneWithID: nil, completionHandler: ({results, error in
            
            println("\(results.count)")
            
            if (error != nil) {
                println("\(error)")
                println("Error Reported")
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), {
                
                    // make sure it executes on main thread
                    // create the brief to load from CKRecord
                    var brief = Brief(status: Status.InProgress)
                    // reference to CKRecord
                    var briefRecord = results.first as CKRecord
                    // load the ID
                    var briefId = briefRecord.recordID.recordName
                    brief.id = briefId
                    // load the progress items
                    var progressList = briefRecord.objectForKey("progress") as Array<String>
                    for i in (0 ..< progressList.count) {
                        brief.addProgress(Progress(content: progressList[i]))
                    }
                    // load the plan list
                    var planList = briefRecord.objectForKey("plans") as Array<String>
                    for i in (0 ..< planList.count) {
                        brief.addPlan(Plan(content: planList[i]))
                    }
                    //load the problem list
                    var problemList = briefRecord.objectForKey("problems") as Array<String>
                    for i in (0 ..< problemList.count) {
                        brief.addProblem(Problem(content: problemList[i]))
                    }
                    
                    user.draftBrief = brief
                })
                
            }
            
        }));
        
    }
    
}
