//
//  SnappingLayout.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 11/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class SnappingLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            
        }
        
        let parent = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        
        let itemWidth = collectionView.frame.width - 48
        let itemSpace = itemWidth + minimumInteritemSpacing
        var pageIdx = round(collectionView.contentOffset.x / itemSpace)
        
        if velocity.x > 0 {
            pageIdx += 1
        } else if velocity.x < 0 {
            pageIdx -= 1
        }
        
        let nearestPageOffset = pageIdx * itemSpace
        return CGPoint(x: nearestPageOffset,
                       y: parent.y)
    }
}
