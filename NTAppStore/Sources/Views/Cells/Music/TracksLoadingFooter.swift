//
//  TracksLoadingFooter.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 23/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class TracksLoadingFooter: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .darkGray
        aiv.startAnimating()
        
        let label = UILabel(text: "Loading...", font: .systemFont(ofSize: 16))
        label.textAlignment = .center
        
        let stackView = VerticalStackView(arrangedSubviews: [
            aiv,
            label
            ], spacing: 8)
        addSubview(stackView)
        stackView.centerInSuperview(size: .init(width: 200, height: 0))
    }
}
