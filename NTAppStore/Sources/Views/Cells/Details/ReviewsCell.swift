//
//  ReviewsCell.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 14/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class ReviewsCell: UICollectionViewCell {
        
    let reviewsController = ReviewsController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        addSubview(reviewsController.view)
        reviewsController.view.fillSuperview()
    }
}
