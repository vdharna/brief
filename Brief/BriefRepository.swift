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
    
    func saveChanges(brief: Brief) -> Bool {
        
        var path = self.briefArchivePath()
        
        // Returns true on success
        return NSKeyedArchiver.archiveRootObject(brief, toFile: path)

    }
    
    func loadDraftBrief() -> Brief? {
        
        var path = self.briefArchivePath()
        return NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? Brief
        
    }
    
    func briefArchivePath() -> String? {
        
        // Make sure that the first argument is NSDocumentDirectory and not NSDocumentationDirectory
        var documentDirectories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        // Get the one document directory from that list
        var documentDirectory: NSString? = documentDirectories[0] as? NSString
        
        return documentDirectory?.stringByAppendingPathComponent("briefs.archive")
        
    }
    
    func saveDraftBrief(brief: Brief) {
        
        //query for the brief object first
        
        var privateDatabase = CKContainer.defaultContainer().privateCloudDatabase
        var briefRecordID = CKRecordID(recordName: brief.getId().UUIDString)
        var briefRecord: CKRecord = CKRecord(recordType: "Brief", recordID: briefRecordID)
        
        //check to see if it exists already
        privateDatabase.fetchRecordWithID(briefRecordID, completionHandler: ({record, error in
            
            if (record != nil) {
                
                briefRecord = record
                println("\(record.recordChangeTag)")
                
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
                println("\(record)")
            }));
            
        }));

    }
    
}
