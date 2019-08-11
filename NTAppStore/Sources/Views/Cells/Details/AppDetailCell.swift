//
//  AppDetailCell.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 11/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class AppDetailCell: UICollectionViewCell {
    
    let appIconImageView = UIImageView(cornerRadius: 26)
    let nameLabel = UILabel(text: "App Name", font: .boldSystemFont(ofSize: 24), numberOfLines: 2)
    let priceButton = UIButton(title: "$4.99")
    let whatsNewLabel = UILabel(text: "What's New", font: .boldSystemFont(ofSize: 20))
    let releaseNotesLabel = UILabel(text: "Release Notes", font: .systemFont(ofSize: 16), numberOfLines: 0)
    
    fileprivate func setupViews() {
        
        appIconImageView.layer.borderColor = UIColor.gray.cgColor
        appIconImageView.layer.borderWidth = 0.3
        appIconImageView.constrainWidth(constant: 140)
        appIconImageView.constrainHeight(constant: 140)
        priceButton.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        priceButton.setTitleColor(.white, for: .normal)
        priceButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        priceButton.constrainHeight(constant: 32)
        priceButton.constrainWidth(constant: 80)
        priceButton.layer.cornerRadius = 16
        
        let stackView = VerticalStackView(arrangedSubviews: [
                UIStackView(arrangedSubviews: [
                    appIconImageView,
                    VerticalStackView(arrangedSubviews: [nameLabel, UIStackView(arrangedSubviews: [priceButton, UIView()]), UIView()], spacing: 12)], customSpacing: 20),
                whatsNewLabel,
                releaseNotesLabel,
            ], spacing: 16)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
