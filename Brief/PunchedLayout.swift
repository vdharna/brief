//
//  PunchedLayout.swift
//  Brief
//
//  Created by Dharminder Dharna on 9/3/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class PunchedLayout: UICollectionViewFlowLayout {
    
    var boundsSize: CGSize?
    var midX: CGFloat?
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func prepareLayout() {
        
        super.prepareLayout()
        
        boundsSize = self.collectionView.bounds.size;
        midX = boundsSize!.width / 2.0;
    }
   
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]! {
        
        var array = super.layoutAttributesForElementsInRect(rect)
        
        for attributes in array  {
            var a = attributes as UICollectionViewLayoutAttributes
            a.transform3D = CATransform3DIdentity
            if (!CGRectIntersectsRect(a.frame, rect)) {continue}
            
            var contentOffset = self.collectionView.contentOffset
            var itemCenter = CGPointMake(a.center.x - contentOffset.x, a.center.y - contentOffset.y)
            
            var distance = abs(midX! - itemCenter.x)
            var normalized = distance / midX!
            normalized = min(1.0, normalized)
            
            var zoom: CGFloat = CGFloat(cos(normalized * CGFloat(M_PI_4)))
            a.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0)
            
        }
        
        return array
        
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        var offsetAdjustment = CGFloat.max
        
        // Retrieve all onscreen items at the proposed starting point
        var targetRect = CGRectMake(proposedContentOffset.x, 0.0, boundsSize!.width, boundsSize!.height)
        var array = super.layoutAttributesForElementsInRect(targetRect)
        
        // Determine the proposed center x-coordinate
        var proposedCenterX = proposedContentOffset.x + midX!
        
        // Search for the minimum offset adjustment
        
            
        for attributes in array  {
            var a = attributes as UICollectionViewLayoutAttributes
            var distance = a.center.x - proposedCenterX
            if (abs(distance) < abs(offsetAdjustment)) {
                offsetAdjustment = distance
            }
        }
        
        var desiredPoint = CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y)
        
        if ((proposedContentOffset.x == 0) || (proposedContentOffset.x >= (self.collectionViewContentSize().width - boundsSize!.width))) {
        }
    
        return desiredPoint
            
    }
    
}

        
//        - (CGPoint) targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
//        {
//            CGFloat offsetAdjustment = CGFLOAT_MAX;
//            
//            // Retrieve all onscreen items at the proposed starting point
//            CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, boundsSize.width, boundsSize.height);
//            NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
//            
//            // Determine the proposed center x-coordinate
//            CGFloat proposedCenterX = proposedContentOffset.x + midX;
//            
//            // Search for the minimum offset adjustment
//            for (UICollectionViewLayoutAttributes* layoutAttributes in array)
//            {
//                CGFloat distance = layoutAttributes.center.x - proposedCenterX;
//                if (ABS(distance) < ABS(offsetAdjustment))
//                offsetAdjustment = distance;
//            }
//            
//            CGPoint desiredPoint = CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
//            
//            if ((proposedContentOffset.x == 0) || (proposedContentOffset.x >= (self.collectionViewContentSize.width - boundsSize.width)))
//            {
//                NSNotification *note = [NSNotification notificationWithName:@"PleaseRecenter" object:[NSValue valueWithCGPoint:desiredPoint]];
//                [[NSNotificationCenter defaultCenter] postNotification:note];
//                return proposedContentOffset;
//            }
//            
//            // Offset the content by the minimal centering
//            return desiredPoint;
//        }

