//
//  AppsGroupCell.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 06/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class AppsGroupCell: UICollectionViewCell {
    
    let sectionTitleLabel = UILabel(text: "App Section", font: .boldSystemFont(ofSize: 30))
    let horizontalViewController = AppsHorizontalController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        addSubview(sectionTitleLabel)
        addSubview(horizontalViewController.view)
        
        sectionTitleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        horizontalViewController.view.anchor(top: sectionTitleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
}
