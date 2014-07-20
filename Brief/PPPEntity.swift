//
//  PPPEntity.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/15/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import Foundation

func ==(lhs: PPPEntity, rhs: PPPEntity) -> Bool {
    return lhs.id == rhs.id
}

class PPPEntity: Equatable, Printable {
    
    var id: String
    var content: String
    
    var description : String { return String(id) }

    
    init(content: String) {
        self.id = NSUUID.UUID().UUIDString
        self.content = content
    }
}