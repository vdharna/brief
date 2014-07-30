//
//  PPPEntity.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/15/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import Foundation


class PPPItem {
    
    private var id: Int
    private var content: String
    private var flag: Flag?
    private var comments: Array<Comment>?
    
    var description : String { return String(id) }
    
    init(content: String) {
        self.id = NSUUID.UUID().hashValue
        self.content = content
    }
    
    init(content: String, flag: Flag) {
        self.id = NSUUID.UUID().hashValue
        self.content = content
        self.flag = flag
    }
    
    func getId() -> Int {
        return self.id
    }
    
    func setContent(content: String) {
        self.content = content
    }
    
    func getContent() -> String {
        return self.content
    }
    
    func isFlagged() -> Bool {
        
        return flag!.isFlagged()
        
    }
    
    func flag(flag: Bool) {
        self.flag!.setFlag(flag)
    }
    
}