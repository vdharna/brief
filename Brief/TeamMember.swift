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
    var archivedBriefs: Dictionary<String, Brief>?
    
    init() {
        firstName = "Dharminder"
        lastName = "Dharna"
        brief = Brief()
    }
    
    func loadArchivedBriefs() {
        archivedBriefs = Dictionary(minimumCapacity: 0)
        //load via server-side archive (e.g. Rest Service or Cloud-Kit)
    }
    
}