//
//  TeamMember.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/14/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import Foundation
import CloudKit

let user = TeamMember()

class TeamMember {
    
    var userInfo: CKDiscoveredUserInfo?
    
    var draftBrief:Brief?
    var completedBriefs = Array<Brief>()
    
    var submittedBrief = false
    private var notificationSubscriptions = Array<String>()
    
    private var cloudManager = BriefCloudManager()
    
    init() {
    }
    
    func getID() -> String? {
        return self.userInfo?.userRecordID.recordName
    }
    
    func getFirstName() -> String? {
        return self.userInfo?.firstName
    }
    
    func getLastName() -> String? {
        return self.userInfo?.lastName
    }
    
    func getDraftBrief() -> Brief {
        return self.draftBrief!
    }
    
    func loadDraftBrief(completionClosure: ((Bool) -> Void)) {
        
        if (self.draftBrief == nil) {
            
            // check for reachability before querying for records in iCloud
            
            self.cloudManager.queryForDraftBrief({ records in
            
                if (records.count > 0) {
                
                    // pull the first record
                    var record = records.first
                
                    var id = record?.recordID.recordName
                    var statusRaw = record?.objectForKey("status") as NSNumber
                    var status = Status.fromRaw(statusRaw)
                
                    var draftBrief = Brief(status: status!)
                    draftBrief.id = id!
                
                    self.draftBrief = draftBrief
                
                } else {
                    
                    // REPLACE with load via local archive by checking user defaults
                    self.draftBrief = Brief(status: .IsNew)

                } //finally create a blank new one if one doesn't exist either in iCloud or local archive
    
                // send the completed value once you load all the parts
                self.draftBrief!.loadPPPItems({ completed in
                    dispatch_async(dispatch_get_main_queue(), {
                        completionClosure(completed)
                    })
                })
            
            })
        }

    }
    
    func loadCompletedBriefs(completionClosure: ((Bool) -> Void)) {
        
        //query for completed briefs
        cloudManager.queryForCompletedBriefs({ records in
            self.completedBriefs.removeAll(keepCapacity: false)
            // loop through array
            for i in (0 ..< records.count) {
                var record = records[i] as CKRecord
                var brief = Brief(status: Status.fromRaw(record.objectForKey("status") as NSNumber)!)
                brief.id = record.recordID.recordName
                brief.submittedDate = record.objectForKey("submittedDate") as? NSDate
                self.completedBriefs.append(brief)
                
                if (i == 0) {
                    // load the first one by default
                    brief.loadPPPItems({ completed in
                        // do nothing
                    })
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                completionClosure(true)
            })
            
        })
    }
    
    
    func getCompletedBriefs() -> Array<Brief> {
        return self.completedBriefs
    }
    
    func loadArchivedBriefsTest() {
        //load via server-side archive (e.g. Rest Service or Cloud-Kit)
        
        // if this is set to 1, load the archive as a sample
        let dic = NSProcessInfo.processInfo().environment
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"; // or whatever you want; per the unicode standards

        var date1 = dateFormatter.dateFromString("2014-03-31")
        var date2 = dateFormatter.dateFromString("2014-04-07")
        var date3 = dateFormatter.dateFromString("2014-04-14")
        var date4 = dateFormatter.dateFromString("2014-04-21")
        var date5 = dateFormatter.dateFromString("2014-04-28")
        var date6 = dateFormatter.dateFromString("2014-05-05")
        var date7 = dateFormatter.dateFromString("2014-05-12")
        var date8 = dateFormatter.dateFromString("2014-05-19")
        var date9 = dateFormatter.dateFromString("2014-05-26")
        var date10 = dateFormatter.dateFromString("2014-06-02")
        var date11 = dateFormatter.dateFromString("2014-06-09")
        var date12 = dateFormatter.dateFromString("2014-06-13")
        var date13 = dateFormatter.dateFromString("2014-06-23")
        var date14 = dateFormatter.dateFromString("2014-06-30")
        var date15 = dateFormatter.dateFromString("2014-07-07")
        var date16 = dateFormatter.dateFromString("2014-07-14")
        var date17 = dateFormatter.dateFromString("2014-07-21")
        var date18 = dateFormatter.dateFromString("2014-07-28")
        var date19 = dateFormatter.dateFromString("2014-08-04")
        var date20 = dateFormatter.dateFromString("2014-08-11")
        
        var dates = [date20, date19, date18, date17, date16, date15, date14, date13, date12, date11, date10, date9, date8, date7, date6, date5, date4, date3, date2, date1]

        //create user archive to test
        for var index = 0; index < 20; ++index {
            var brief = BriefArchiveDebugLoadUtility.createSampleBrief()
            brief.submittedDate = dates[index]
            completedBriefs.append(brief)
        }
        

    }
    
    func addNotification(id: String) {
        self.notificationSubscriptions.append(id)
    }
    
    func removeNotification(id: String) {
        
        var index = find(self.notificationSubscriptions, id)
        if (index != nil) {
            self.notificationSubscriptions.removeAtIndex(index!)
        }
    }
    
    func containsNotification(id: String) -> Bool {
        return find(self.notificationSubscriptions, id) != nil
    }
    
    func findBriefById(id: String, completionClosure: (brief: Brief?) ->()) {
        
        var brief: Brief?
        // loop through each array
        for i in (0 ..< completedBriefs.count) {
            if completedBriefs[i].getId().isEqual(id) {
                brief = completedBriefs[i]
            }
        }
        
        brief?.loadPPPItems({ completed in
            dispatch_async(dispatch_get_main_queue(), {
                completionClosure(brief: brief?)
            })
        })

    }
    
    func getMostRecentBrief() -> Brief {
        // need to make this smarter by latest submitted date
        return self.completedBriefs[0]
    }
    
    func deleteBrief() {
        self.draftBrief = Brief(status: .IsNew)
    }
    
    func submitBrief(completionClosure: ((Bool) -> Void)) {
        
        cloudManager.fetchRecordWithID(self.draftBrief!.getId(), completionClosure: {record in
            
            // update the draft brief status
            self.draftBrief!.status = Status.IsCompleted
            self.draftBrief!.submittedDate = NSDate()
            record.setObject(self.draftBrief!.status.toRaw(), forKey: "status")
            record.setObject(self.draftBrief!.submittedDate, forKey: "submittedDate")
            // save the record to iCloud
            self.cloudManager.saveRecord(record, completionClosure: { success in
                // remove the brief from local
                self.completedBriefs.insert(self.draftBrief!, atIndex: 0)
                self.deleteBrief()
                self.submittedBrief = true
                dispatch_async(dispatch_get_main_queue(), {
                    completionClosure(true)
                })
            })


        })
    }

    
}