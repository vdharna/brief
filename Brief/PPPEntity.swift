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

var id: Int = 0

class PPPEntity: Equatable, Printable {
    
    var id: Int
    var content: String
    
    var description : String { return String(id) }

    
    init(content: String) {
        self.id = NSUUID.UUID().hashValue
        self.content = content
    }
}