//
//  TeamMember.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/14/14.
//  Copyright (c) 2014 Smpl Enterprise. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

let user = TeamMember()

class TeamMember {
    
    var userInfo: CKDiscoveredUserInfo?
    var preferredName: String?
    var image: UIImage?
    
    var briefReviewers = Array<TeamMember>()
    
    var draftBrief:Brief?
    var completedBriefs = Array<Brief>()
    var submittedBrief = false
    var discoverableUsers = Array<TeamMember>()
    
    private var cloudManager = BriefCloudManager()
    
    init() {
    }
    
    func getID() -> String? {
        return self.userInfo?.userRecordID.recordName
    }
    
    func getFirstName() -> String {
        if let firstName =  self.userInfo?.firstName {
            return firstName
        }
        
        return "Unknown"
    }
    
    func getLastName() -> String {
        if let lastName = userInfo?.lastName {
            return lastName
        }
        
        return "Unknown" //use user defaults
        
    }
    
    func getPreferredName() -> String? {
        return preferredName
    }
    
    func updatePreferredName(name: String) {
        
        if (name.isEmpty) {
            self.preferredName = nil
        } else {
            self.preferredName = name
        }

        if let recordID = userInfo?.userRecordID.recordName {
            self.cloudManager.fetchRecordWithID(recordID, completionClosure: { record in
                if (name.isEmpty) {
                    record.setObject(nil, forKey: "preferredName")
                } else {
                    record.setObject(name, forKey: "preferredName")
                }
                self.cloudManager.saveRecord(record, completionClosure: { completion in
                })
                
            })
        }

    }
    
    func getImage() -> UIImage? {
        return self.image
    }
    
    func getDraftBrief() -> Brief {
        return self.draftBrief!
    }
    
    func updateProfileImage(image: UIImage) {
        
        self.image = image
    }
    
    func deleteProfilePhoto() {
        
        self.image = nil

        if let recordID = userInfo?.userRecordID.recordName {
            self.cloudManager.fetchRecordWithID(recordID, completionClosure: { record in
                record.setObject(nil, forKey: "photo")
                self.cloudManager.saveRecord(record, completionClosure: { completion in
                })
                
            })
        }

    }
    
    func loadDraftBrief(completionClosure: ((Bool) -> Void)) {
        
        if (self.draftBrief == nil) {
            
            // check for reachability before querying for records in iCloud
            
            self.cloudManager.queryForDraftBrief({ records in
            
                if (records.count > 0) {
                
                    // pull the first record
                    var record = records.first
                
                    var id = record?.recordID.recordName
                    var statusRaw = record?.objectForKey(StatusField) as Int
                    
                    if let status = Status(rawValue: statusRaw) {
                        var draftBrief = Brief(status: status)
                        draftBrief.id = id!
                        
                        self.draftBrief = draftBrief
                    }
                    

                
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
                if let status = Status(rawValue: record.objectForKey(StatusField) as Int) {
                    var brief = Brief(status: status)
                    brief.id = record.recordID.recordName
                    brief.submittedDate = record.objectForKey(SubmittedDateField) as? NSDate
                    self.completedBriefs.append(brief)
                    
                    if (i == 0) {
                        // load the first one by default
                        brief.loadPPPItems({ completed in
                            // do nothing
                        })
                    }
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

    
    func addNotification(item: PPPItem, completionClosure: ((Bool) -> Void)) {
        
        cloudManager.subscribeForComments(item, completionClosure: { subscription in
            
            var subscriptionID = subscription.subscriptionID as String
            
            //add to NSUserDefaults
            var defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(subscriptionID, forKey: item.id)
            
            dispatch_async(dispatch_get_main_queue(), {
                completionClosure(true)
            })
            
        })

    }
    
    func removeNotification(id: String) {
        
        var defaults = NSUserDefaults.standardUserDefaults()
        var subscriptionID = defaults.objectForKey(id) as String
        defaults.removeObjectForKey(id)

        self.cloudManager.unsubscribe(subscriptionID)
        
    }
    
    func containsNotification(id: String) -> Bool {
        var defaults = NSUserDefaults.standardUserDefaults()
        if (defaults.objectForKey(id) == nil) {
            return false
        }
        return true
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
    
    func submitBrief(completionClosure: ((Bool) -> ())) {
        
        cloudManager.fetchRecordWithID(self.draftBrief!.getId(), completionClosure: {record in
            
            // update the draft brief status
            self.draftBrief!.status = Status.IsCompleted
            self.draftBrief!.submittedDate = NSDate()
            record.setObject(self.draftBrief!.status.rawValue, forKey: StatusField)
            record.setObject(self.draftBrief!.submittedDate, forKey: SubmittedDateField)
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
    
    func loadBriefReviewers(count: Int) {
        
        for var index = 0; index < count; ++index {
            var teamMember = TeamMember()
            teamMember.preferredName = index.description
            self.briefReviewers.append(teamMember)
        }

    }
    
    func getAllDiscoverableUsers(completionClosure: ((Bool) -> ())) {
        
        self.discoverableUsers.removeAll(keepCapacity: true)
        
        self.cloudManager.discoverAllContactUserInfos({ userInfos in
            
            var recordIDs = Array<CKRecordID>()
            
            for userInfo in userInfos {
                var teamMember = TeamMember()
                teamMember.userInfo = userInfo
                self.discoverableUsers.append(teamMember)
                
                recordIDs.append(userInfo.userRecordID)
            }
            
            var fetchRecords = CKFetchRecordsOperation(recordIDs: recordIDs)
            
            fetchRecords.fetchRecordsCompletionBlock = { recordsByRecordID, operationError in
                
                for teamMember in self.discoverableUsers {
                    
                    if let userInfo = teamMember.userInfo {
                        var record = recordsByRecordID[userInfo.userRecordID] as CKRecord
                        
                        if let preferredName = record.objectForKey("preferredName") as? String {
                            if (!preferredName.isEmpty) {
                                teamMember.preferredName = preferredName
                            }
                        }
                        
                        if let photoAsset = record.objectForKey("photo") as? CKAsset {
                            var image = UIImage(contentsOfFile: photoAsset.fileURL.path!)
                            teamMember.image = image
                        }
                    }
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    completionClosure(true)
                })
            }
            
            self.cloudManager.publicDatabase.addOperation(fetchRecords)
        })
    }
}