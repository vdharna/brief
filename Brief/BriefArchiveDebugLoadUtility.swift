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
        
        var brief = Brief(status: .Completed)
        
        populateProgress(brief)
        populatePlans(brief)
        populateProbelems(brief)
        
        return brief
    }
    
    private class func populateProgress(brief: Brief) {
        
        for var index = 0; index < 3; ++index {
            let randomIndex = Int(arc4random_uniform(UInt32(samples.count)))
            var p = Progress(content: "Progress: " + samples[randomIndex])
            populateComments(p);
            brief.addProgress(p)
        }
    
    }
    
    private class func populatePlans(brief: Brief) {
        
        for var index = 0; index < 3; ++index {
            let randomIndex = Int(arc4random_uniform(UInt32(samples.count)))
            var p = Plan(content: "Plan: " + samples[randomIndex])
            populateComments(p);
            brief.addPlan(p)

        }
        
    }
    
    private class func populateProbelems(brief: Brief) {
        
        for var index = 0; index < 3; ++index {
            let randomIndex = Int(arc4random_uniform(UInt32(samples.count)))
            var p = Problem(content: "Problem: " + samples[randomIndex])
            populateComments(p);
            brief.addProblem(p)
        }
    }
    
    private class func populateComments(item: PPPItem) {
        
        for var index = 0; index < 3; ++index {
            let randomIndex = Int(arc4random_uniform(UInt32(comments.count)))
            var c = Comment(content: comments[randomIndex], createdDate: NSDate(), createdBy: user )
            //item.addComment(c)
        }
    }
    
    
}

let samples = ["Today's date is xi.xii.xiii which is significant because it looks like a child doing star-jumps so well that a crowd starts to form.", "I'm starting to think that the Facebook status update I liked has had absolutely no influence on Government policy at all.", "I'm at the vets. A man opposite me weeps with an empty cage in his arms. I'd be crying too if I were that forgetful.", "Ten, Twenty, Thirty, fourty, fifty, sixty, sixtyten, \"what?\" four twenties, \"France, stop it\" four twenties and ten. \"France you're drunk\"", "So many pigs seem to die while eating an apple.", "I must be ill - I thought I saw a sausage fly past my window, but it was actually a seabird. I think I've taken a tern for the wurst.", "How to cook the perfect amount of pasta:1. Pour out how much you think you need  2. Wrong", "Justin Bieber gets 40,000 retweets just for tweeting 'Hello', so here's my attempt: Hele0iM1. Ah, harder than it looks. Fair play to him.", "Girlfriend said last night \"You treat our relationship like some kind of game!\" Which unfortunately cost her 12 points and a bonus chance.", "The Tesco Everyday Value lasagne is so horrible, the serving suggestion on the box is just a picture of it in a bin.", "If people don't wish to discuss the cruel existential futility of all human endeavour they shouldn't say Good Morning in the first place."]

let comments = ["It’s the details. The innovations. The complete experience. It’s the fact that you can now see (and edit and organize) every photo you take on all your devices. That you can add your voice right in a text message. And that your health and fitness apps can now communicate with each other, with your trainer, and even with your doctor.", "We’ve also provided developers with deeper access and more tools. So some of the most amazing features in iOS 8 are being created right now. You’ll have new keyboard options and even more ways to share your content. And you’ll be able to use iCloud and Touch ID in ways you never have before.", "It’s going to be a great Fall. But for now, here’s a preview of some of the things iOS 8 will do for you so you can do more than ever.", "Every photo, every edit, every album now lives in your iCloud Photo Library, easily viewable and consistent on all your devices. Automatically. The all-new Photos app makes it simpler than ever to find and rediscover your favorite photos. And you can make every shot look even better immediately after you’ve taken it with powerful new editing tools.", "Now Messages lets you connect with friends and family like never before. Tap to add your voice to any conversation. Send a video of what you’re seeing the moment you’re seeing it. And easily share your location so they know right where you are.", "In iOS 8, you’ll find a convenient new way to respond to notifications. Helpful shortcuts to the people you talk to most. And time-saving features for managing your mail. All of which make the experience of using your iPhone, iPad, or iPod touch that much better.", "iOS 8 makes typing easier by suggesting contextually appropriate words to complete your sentences. It even recognizes to whom you’re typing and whether you’re in Mail or Messages. Because your tone in an email may be different from your tone in a message.", "Family Sharing makes it easy for up to six people in your family to share each other’s iTunes, iBooks, and App Store purchases. Whenever one person buys a new song, movie, or app, everybody gets to share. It’s also easier than ever to share family photos, a family calendar, locations, and more.", "The good news: You can work on any file, anywhere. The bad news: You can work on any file, anywhere. That includes presentations, PDFs, images, and more — right from iCloud. On whichever device you’re using, including your Mac or PC."]
