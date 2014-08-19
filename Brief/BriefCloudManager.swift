//
//  BriefCloudManager.swift
//  Brief
//
//  Created by Dharminder Dharna on 8/18/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import Foundation
import CloudKit

class BriefCloudManager {
    
    var container: CKContainer
    var publicDatabase: CKDatabase
    
    init() {
        
        self.container = CKContainer.defaultContainer()
        self.publicDatabase = container.publicCloudDatabase
    }
    
    func requestDiscoverabilityPermission(completionClosure: ((Bool) -> Void)) {
        
        self.container.requestApplicationPermission(CKApplicationPermissions.PermissionUserDiscoverability, completionHandler: {applicationPermissionStatus, error in
            
            if (error != nil) {
                
                println("\(error)")
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), {
                    completionClosure(applicationPermissionStatus == CKApplicationPermissionStatus.Granted)
                })
                
            }
            
        });
        
    }
    
    func discoverUserInfo(completionClosure: (userInfo :CKDiscoveredUserInfo) ->()) {
        
        self.container.fetchUserRecordIDWithCompletionHandler({recordID, error in
            if (error != nil) {
                println("\(error)")
            } else {
                self.container.discoverUserInfoWithUserRecordID(recordID, completionHandler: {user, error in
                    if (error != nil) {
                        println("\(error)")
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            completionClosure(userInfo: user)
                        })
                    }
                });
            }
        });
    }
}
