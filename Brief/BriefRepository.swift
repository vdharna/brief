//
//  BriefRepository.swift
//  Brief
//
//  Created by Dharminder Dharna on 8/14/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import Foundation

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
}
