//
//  BriefArchiveDebugLoadUtility.swift
//  Brief
//
//  Created by Dharminder Dharna on 7/27/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import Foundation

class BriefArchiveDebugLoadUtility {
    
    class func createSampleBrief() -> Brief {
        
        var brief = Brief()
        
        populateProgress(brief)
        populatePlans(brief)
        populateProbelems(brief)
        
        return brief
    }
    
    private class func populateProgress(brief: Brief) {
        
        for var index = 0; index < 3; ++index {
            let randomIndex = Int(arc4random_uniform(UInt32(samples.count)))
            var p = Progress(content: "Progress: " + samples[randomIndex], flag: Flag())
            brief.addProgress(p)
        }
    
    }
    
    private class func populatePlans(brief: Brief) {
        
        for var index = 0; index < 3; ++index {
            let randomIndex = Int(arc4random_uniform(UInt32(samples.count)))
            var p = Plan(content: "Plan: " + samples[randomIndex], flag: Flag())
            brief.addPlan(p)

        }
        
    }
    
    private class func populateProbelems(brief: Brief) {
        
        for var index = 0; index < 3; ++index {
            let randomIndex = Int(arc4random_uniform(UInt32(samples.count)))
            var p = Problem(content: "Problem: " + samples[randomIndex], flag: Flag())
            brief.addProblem(p)
        }
    }
    
    
}

let samples = ["Today's date is xi.xii.xiii which is significant because it looks like a child doing star-jumps so well that a crowd starts to form.", "I'm starting to think that the Facebook status update I liked has had absolutely no influence on Government policy at all.", "I'm at the vets. A man opposite me weeps with an empty cage in his arms. I'd be crying too if I were that forgetful.", "Ten, Twenty, Thirty, fourty, fifty, sixty, sixtyten, \"what?\" four twenties, \"France, stop it\" four twenties and ten. \"France you're drunk\"", "So many pigs seem to die while eating an apple.", "I must be ill - I thought I saw a sausage fly past my window, but it was actually a seabird. I think I've taken a tern for the wurst.", "How to cook the perfect amount of pasta:1. Pour out how much you think you need  2. Wrong", "Justin Bieber gets 40,000 retweets just for tweeting 'Hello', so here's my attempt: Hele0iM1. Ah, harder than it looks. Fair play to him.", "Girlfriend said last night \"You treat our relationship like some kind of game!\" Which unfortunately cost her 12 points and a bonus chance.", "The Tesco Everyday Value lasagne is so horrible, the serving suggestion on the box is just a picture of it in a bin.", "If people don't wish to discuss the cruel existential futility of all human endeavour they shouldn't say Good Morning in the first place."]
