//
//  ScreenshotCell.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 13/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class ScreenshotCell: UICollectionViewCell {
    
    let screenshotImageView = UIImageView(cornerRadius: 8)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        screenshotImageView.backgroundColor = .yellow
        addSubview(screenshotImageView)
        screenshotImageView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}


