//
//  AppsPageHeader.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 09/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class AppsPageHeader: UICollectionReusableView {
    
    let appHeaderHorizontalController = AppsHeaderHorizontalController()
    
    fileprivate func setupViews() {
        
        addSubview(appHeaderHorizontalController.view)
        appHeaderHorizontalController.view.fillSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
