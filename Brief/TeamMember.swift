//
//  TeamMember.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/14/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import Foundation

let user = TeamMember()

class TeamMember: NSObject, NSCoding {
    
    private var id: String
    private var firstName: String
    private var lastName: String
    
    private var draftBrief:Brief?
    private var completedBriefs: Array<Brief>?
    private var notificationSubscriptions = Array<NSUUID>()
    
    override init() {
        self.id = "1"
        self.firstName = "Dharminder"
        self.lastName = "Dharna"
    }
    
    func getDraftBrief() -> Brief {
        
        if (self.draftBrief == nil) {
            
            // check to see if there's a brief stored in the local filesystem
            var brief = BriefRepository().loadDraftBrief()
            
            if (brief != nil) {
                
                self.draftBrief = brief
                
            } else {
                
                self.draftBrief = Brief(status: .New)

            }
        }
        return self.draftBrief!
    }
    
    func getCompletedBriefs() -> Array<Brief> {
        
        if (completedBriefs == nil) {
            self.completedBriefs = Array<Brief>()
            self.loadArchivedBriefs()
        }
        return self.completedBriefs!
    }
    
    func loadArchivedBriefs() {
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

        if dic["debug"] != nil {
            //create user archive to test
            for var index = 0; index < 20; ++index {
                var brief = BriefArchiveDebugLoadUtility.createSampleBrief()
                brief.submittedDate = dates[index]
                completedBriefs!.append(brief)
            }
        }

    }
    
    func addNotification(id: NSUUID) {
        self.notificationSubscriptions.append(id)
    }
    
    func removeNotification(id: NSUUID) {
        
        var index = find(self.notificationSubscriptions, id)
        if (index != nil) {
            self.notificationSubscriptions.removeAtIndex(index!)
        }
    }
    
    func containsNotification(id: NSUUID) -> Bool {
        return find(self.notificationSubscriptions, id) != nil
    }
    
    func findBriefById(id: NSUUID) -> Brief? {
        
        var brief: Brief?
        // loop through each array
        for i in (0 ..< completedBriefs!.count) {
            if completedBriefs![i].getId().isEqual(id) {
                brief = completedBriefs![i]
            }
        }
        return brief
    }
    
    func getMostRecentBrief() -> Brief {
        // need to make this smarter by latest submitted date
        return self.completedBriefs![0]
    }
    
    func deleteBrief() {
        self.draftBrief = Brief(status: .New)
    }
    
    
    func encodeWithCoder(aCoder: NSCoder!) {
        
        aCoder.encodeObject(self.id, forKey: "id")
        aCoder.encodeObject(self.firstName, forKey: "firstName")
        aCoder.encodeObject(self.lastName, forKey: "lastName")
        aCoder.encodeObject(self.draftBrief, forKey: "draftBrief")
        aCoder.encodeObject(self.notificationSubscriptions, forKey: "notificationSubscriptions")
        
    }
    
    required init(coder aDecoder: NSCoder!) {
        
        self.id = aDecoder.decodeObjectForKey("id") as String
        self.firstName = aDecoder.decodeObjectForKey("firstName") as String
        self.lastName = aDecoder.decodeObjectForKey("lastName") as String
        self.draftBrief = aDecoder.decodeObjectForKey("draftBrief") as? Brief
        self.notificationSubscriptions = aDecoder.decodeObjectForKey("notificationSubscriptions") as Array<NSUUID>
        
    }
}