//
//  Brief.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/14/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import Foundation

let StatusField = "status" // int
let SubmittedDateField = "submittedDate" //date

let BriefRecordType = "Brief"

class Brief {
    
    var id: String
    var progress: Array<Progress>
    var plans: Array<Plan>
    var problems: Array<Problem>
    var submittedDate: NSDate?
    var status: Status
    
    private var cloudManager = BriefCloudManager()
    
    init(status: Status) {
        self.id = NSUUID().UUIDString
        self.progress = Array<Progress>()
        self.plans = Array<Plan>()
        self.problems = Array<Problem>()
        self.status = status
    }
    
    func getId() -> String {
        return self.id
    }
    
    func addProgress(p: Progress) {
        
        self.progress.append(p)
        if (self.status == Status.IsNew) {
            self.status = Status.InProgress
        }
        
    }
    
    func addPlan(p: Plan) {
        self.plans.append(p)
        if (self.status == Status.IsNew) {
            self.status = Status.InProgress
        }
    }
    
    func addProblem(p: Problem) {
        self.problems.append(p)
        if (self.status == Status.IsNew) {
            self.status = Status.InProgress
        }    }
    
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
    
    func isEmpty() -> Bool {
        if ((self.progress.isEmpty) && (self.plans.isEmpty) && (self.problems.isEmpty)) {
            return true
        } else {
            return false
        }
    }
    
    func findItemById(id: String) -> PPPItem {
        
        // loop through each array
        for i in (0 ..< progress.count) {
            if progress[i].getId().isEqual(id) {
                return progress[i]
            }
        }
        
        // loop through each array
        for i in (0 ..< plans.count) {
            if plans[i].getId().isEqual(id) {
                return plans[i]
            }
        }
        
        // loop through each array
        for i in (0 ..< problems.count) {
            if problems[i].getId().isEqual(id) {
                return problems[i]
            }
        }
        
        return PPPItem(content: "")
    }
    
    func submit() {
        self.submittedDate = NSDate()
    }
    
    func loadPPPItems(completionClosure: ((Bool) -> Void)) {
        
        self.loadProgressItemsFromiCloud({ completed in
            
            self.loadPlanItemsFromiCloud({ completed in
                
                self.loadProblemItemsFromiCloud({ completed in
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        completionClosure(true)
                    })
                    
                })
            })
        })

    }
    
    private func loadProgressItemsFromiCloud(completionClosure: ((Bool) -> Void)) {
        
        self.cloudManager.queryForItemRecordsWithReferenceNamed(self.id, recordType: ProgressRecordType, completionClosure: { records in
            
            self.progress.removeAll(keepCapacity: true)
            
            for i in (0 ..< records.count) {
                var id = records[i].recordID.recordName
                var content = records[i].objectForKey(ItemContentField) as String
                var flag = records[i].objectForKey(FlagField) as Bool
                var hasComments = records[i].objectForKey(HasCommentsField) as Bool
                
                var progress = Progress(content: content)
                progress.id = id
                progress.setFlag(flag)
                progress.containsComments = hasComments
                
                self.addProgress(progress)
            }
            
            if (self.progress.isEmpty && self.status == Status.IsCompleted) {
                
                var id = ""
                var content = "This Brief does not contain any Progress items"
                
                var progress = Progress(content: content)
                progress.id = id
                
                self.addProgress(progress)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                completionClosure(true)
            })
            
        })
    }
    
    private func loadPlanItemsFromiCloud(completionClosure: ((Bool) -> Void)) {
        
        self.cloudManager.queryForItemRecordsWithReferenceNamed(self.id, recordType: PlanRecordType, completionClosure: { records in
            
            self.plans.removeAll(keepCapacity: true)
            
            for i in (0 ..< records.count) {
                var id = records[i].recordID.recordName
                var content = records[i].objectForKey(ItemContentField) as String
                var flag = records[i].objectForKey(FlagField) as Bool
                var hasComments = records[i].objectForKey(HasCommentsField) as Bool
                
                var plan = Plan(content: content)
                plan.id = id
                plan.setFlag(flag)
                plan.containsComments = hasComments
    
                
                self.addPlan(plan)
            }
            
            if (self.plans.isEmpty && self.status == Status.IsCompleted) {
                
                var id = ""
                var content = "This Brief does not contain any Plan items"
                
                var plan = Plan(content: content)
                plan.id = id
                
                self.addPlan(plan)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                completionClosure(true)
            })
            
        })
    }
    
    private func loadProblemItemsFromiCloud(completionClosure: ((Bool) -> Void)) {
        
        self.cloudManager.queryForItemRecordsWithReferenceNamed(self.id, recordType: ProblemRecordType, completionClosure: { records in
            
            self.problems.removeAll(keepCapacity: true)
            
            for i in (0 ..< records.count) {
                var id = records[i].recordID.recordName
                var content = records[i].objectForKey(ItemContentField) as String
                var flag = records[i].objectForKey(FlagField) as Bool
                var hasComments = records[i].objectForKey(HasCommentsField) as Bool
                
                var problem = Problem(content: content)
                problem.id = id
                problem.setFlag(flag)
                problem.containsComments = hasComments

                self.addProblem(problem)
            }
            
            if (self.problems.isEmpty && self.status == Status.IsCompleted) {
                
                var id = ""
                var content = "This Brief does not contain any Problem items"
                
                var problem = Problem(content: content)
                problem.id = id
                
                self.addProblem(problem)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                completionClosure(true)
            })
            
            
        })
    }

}
 