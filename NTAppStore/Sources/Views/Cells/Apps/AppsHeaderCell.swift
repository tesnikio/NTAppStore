//
//  AppsHeaderCell.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 09/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class AppsHeaderCell: UICollectionViewCell {
    
    let companyLabel = UILabel(text: "Facebook", font: .boldSystemFont(ofSize: 12), textColor: #colorLiteral(red: 0, green: 0.4779999852, blue: 1, alpha: 1))
    let titleLabel = UILabel(text: "Keeping up with friends is faster than ever", font: .systemFont(ofSize: 24), numberOfLines: 0)
    let adImageView = UIImageView(cornerRadius: 8)
    
    fileprivate func setupViews() {        
        let stackView = VerticalStackView(arrangedSubviews: [companyLabel, titleLabel, adImageView], spacing: 12)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 16, left: 0, bottom: 0, right: 0))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
