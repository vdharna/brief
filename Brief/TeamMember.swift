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
    
    var firstName: String
    var lastName: String
    
    var brief:Brief //current brief
    private var completedBriefs: Array<Brief>
    private var notificationSubscriptions = Array<Int>()
    
    init() {
        firstName = "Dharminder"
        lastName = "Dharna"
        brief = Brief()
        completedBriefs = Array()
    }
    
    func getCompletedBriefs() -> Array<Brief> {
        
        //load archived briefs
        loadArchivedBriefs()
        
        return self.completedBriefs
    }
    
    private func loadArchivedBriefs() {
        //load via server-side archive (e.g. Rest Service or Cloud-Kit)
        
        // if this is set to 1, load the archive as a sample
        let dic = NSProcessInfo.processInfo().environment
        if dic["debug"] != nil {
            //create user archive to test
            for var index = 0; index < 3; ++index {
                var brief = BriefArchiveDebugLoadUtility.createSampleBrief()
                var id = brief.getId()
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
    
}