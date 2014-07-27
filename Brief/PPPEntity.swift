//
//  PPPEntity.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/15/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import Foundation


class PPPEntity {
    
    private var id: Int
    var content: String
    
    var isFlagged = false
    
    var description : String { return String(id) }

    
    init(content: String) {
        self.id = NSUUID.UUID().hashValue
        self.content = content
    }
    
    func getId() -> Int {
        return self.id
    }
    
    
}