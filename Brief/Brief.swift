//
//  Brief.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/14/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import Foundation

class Brief {
    
    private let id: Int
    var progress: Array<Progress>
    var plans: Array<Plan>
    var problems: Array<Problem>
    
    init() {
        id = NSUUID.UUID().hashValue
        progress = []
        plans = []
        problems = []
    }
    
    func getId() -> Int {
        return self.id
    }
    
    func addProgress(p: Progress) {
        self.progress.append(p)
    }
    
    func addPlan(p: Plan) {
        self.plans.append(p)
    }
    
    func addProblem(p: Problem) {
        self.problems.append(p)
    }
    
    func updateProgress(index: Int, p: Progress) {
        self.progress.removeAtIndex(index)
        self.progress.insert(p, atIndex: index)
    }
    
    func updatePlan(index: Int, p: Plan) {
        self.plans.removeAtIndex(index)
        self.plans.insert(p, atIndex: index)
    }
    
    func updateProblem(index: Int, p: Problem) {
        self.problems.removeAtIndex(index)
        self.problems.insert(p, atIndex: index)
    }
    
    func moveProgress(from:Int, to: Int) {
        var p = self.progress.removeAtIndex(from)
        self.progress.insert(p, atIndex: to)
    }
    
    func movePlan(from:Int, to: Int) {
        var p = self.plans.removeAtIndex(from)
        self.plans.insert(p, atIndex: to)
    }
    
    func moveProblem(from:Int, to: Int) {
        var p = self.problems.removeAtIndex(from)
        self.problems.insert(p, atIndex: to)
    }
    
    func deleteProgress(index: Int) {
        self.progress.removeAtIndex(index)
    }
    
    func deletePlan(index: Int) {
        self.plans.removeAtIndex(index)
    }
    
    func deleteProblem(index: Int) {
        self.problems.removeAtIndex(index)
    }
    
    
    func delete() {
        self.problems.removeAll(keepCapacity: false)
        self.plans.removeAll(keepCapacity: false)
        self.progress.removeAll(keepCapacity: false)
    }
    
    func isEmpty() -> Bool {
        if ((self.progress.isEmpty) && (self.plans.isEmpty) && (self.problems.isEmpty)) {
            return true
        } else {
            return false
        }
    }
    
    func findItemById(id: Int) -> PPPItem {
        
        // loop through each array
        for i in (0 ..< progress.count) {
            if progress[i].getId() == id {
                return progress[i]
            }
        }
        
        // loop through each array
        for i in (0 ..< plans.count) {
            if plans[i].getId() == id {
                return plans[i]
            }
        }
        
        // loop through each array
        for i in (0 ..< problems.count) {
            if problems[i].getId() == id {
                return problems[i]
            }
        }
        
        return PPPItem(content: "")
    }

}
