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
    var archivedBriefs: Dictionary<Int, Brief>
    
    init() {
        firstName = "Dharminder"
        lastName = "Dharna"
        brief = Brief()
        archivedBriefs = Dictionary(minimumCapacity: 0)
    }
    
    func loadArchivedBriefs() {
        //load via server-side archive (e.g. Rest Service or Cloud-Kit)
        
        // if this is set to 1, load the archive as a sample
        let dic = NSProcessInfo.processInfo().environment
        if dic["debug"] {
            //create user archive to test
            for var index = 0; index < 3; ++index {
                var brief = BriefArchiveDebugLoadUtility.createSampleBrief()
                var id = brief.getId()
                archivedBriefs.updateValue(brief, forKey: id)
            }
        }

    }
    
}