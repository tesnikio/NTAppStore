//
//  TodayCell.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 16/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class TodayCell: UICollectionViewCell {
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "garden.png"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 16
        clipsToBounds = true
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.centerInSuperview(size: .init(width: 220, height: 220))
    }
}
