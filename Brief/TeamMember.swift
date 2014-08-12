//
//  TeamMember.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/14/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import Foundation

let user = TeamMember()

class TeamMember {
    
    private var firstName: String
    private var lastName: String
    
    private var brief:Brief //current brief
    private var completedBriefs: Array<Brief>
    private var notificationSubscriptions = Array<Int>()
    
    init() {
        firstName = "Dharminder"
        lastName = "Dharna"
        brief = Brief()
        completedBriefs = Array()
    }
    
    func getBrief() -> Brief {
        return self.brief
    }
    
    func getCompletedBriefs() -> Array<Brief> {
        
        return self.completedBriefs
    }
    
    func loadArchivedBriefs() {
        //load via server-side archive (e.g. Rest Service or Cloud-Kit)
        
        // if this is set to 1, load the archive as a sample
        let dic = NSProcessInfo.processInfo().environment
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"; // or whatever you want; per the unicode standards
        // date 1
        var date1 = dateFormatter.dateFromString("2014-01-01")
        var date2 = dateFormatter.dateFromString("2014-02-02")
        var date3 = dateFormatter.dateFromString("2014-03-03")
        var date4 = dateFormatter.dateFromString("2014-04-04")
        var date5 = dateFormatter.dateFromString("2014-05-05")
        var date6 = dateFormatter.dateFromString("2014-06-06")
        var date7 = dateFormatter.dateFromString("2014-07-07")
        var date8 = dateFormatter.dateFromString("2014-08-08")
        var date9 = dateFormatter.dateFromString("2014-10-09")
        var date10 = dateFormatter.dateFromString("2014-11-10")
        
        var dates = [date1, date2, date3, date4, date5, date6, date7, date8, date9, date10]

        if dic["debug"] != nil {
            //create user archive to test
            for var index = 0; index < 10; ++index {
                var brief = BriefArchiveDebugLoadUtility.createSampleBrief()
                brief.submittedDate = dates[index]
                completedBriefs.append(brief)
            }
        }

    }
    
    func addNotification(id: Int) {
        self.notificationSubscriptions.append(id)
    }
    
    func removeNotification(id: Int) {
        
        var index = find(self.notificationSubscriptions, id)
        if (index != nil) {
            self.notificationSubscriptions.removeAtIndex(index!)
        }
        
    }
    
    func containsNotification(id: Int) -> Bool {
        return find(self.notificationSubscriptions, id) != nil
    }
    
    func findBriefById(id: Int) -> Brief {
        
        var brief: Brief?
        // loop through each array
        for i in (0 ..< completedBriefs.count) {
            if completedBriefs[i].getId() == id {
                brief = completedBriefs[i]
            }
        }
        return brief!
    }
    
    func getMostRecentBrief() -> Brief {
        return self.completedBriefs[0]
    }
}