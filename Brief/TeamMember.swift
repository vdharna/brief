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

        var date1 = dateFormatter.dateFromString("2014-01-07")
        var date2 = dateFormatter.dateFromString("2014-02-02")
        var date3 = dateFormatter.dateFromString("2014-02-14")
        var date4 = dateFormatter.dateFromString("2014-02-18")
        var date5 = dateFormatter.dateFromString("2014-03-25")
        var date6 = dateFormatter.dateFromString("2014-04-01")
        var date7 = dateFormatter.dateFromString("2014-05-31")
        var date8 = dateFormatter.dateFromString("2014-06-21")
        var date9 = dateFormatter.dateFromString("2014-07-04")
        var date10 = dateFormatter.dateFromString("2014-07-21")
        var date11 = dateFormatter.dateFromString("2014-08-01")
        var date12 = dateFormatter.dateFromString("2014-08-27")
        var date13 = dateFormatter.dateFromString("2014-09-01")
        var date14 = dateFormatter.dateFromString("2014-09-21")
        var date15 = dateFormatter.dateFromString("2014-10-05")
        var date16 = dateFormatter.dateFromString("2014-10-31")
        var date17 = dateFormatter.dateFromString("2014-11-01")
        var date18 = dateFormatter.dateFromString("2014-11-27")
        var date19 = dateFormatter.dateFromString("2014-12-01")
        var date20 = dateFormatter.dateFromString("2014-12-31")
        
        var dates = [date1, date2, date3, date4, date5, date6, date7, date8, date9, date10, date11, date12, date13, date14, date15, date16, date17, date18, date19, date20]

        if dic["debug"] != nil {
            //create user archive to test
            for var index = 0; index < 20; ++index {
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
        // need to make this smarter by latest submitted date
        return self.completedBriefs[0]
    }
}