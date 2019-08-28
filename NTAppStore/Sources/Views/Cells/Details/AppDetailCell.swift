//
//  AppDetailCell.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 11/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class AppDetailCell: UICollectionViewCell {
  
  var app: AppSearchResult! {
    didSet {
      nameLabel.text = app?.trackName
      releaseNotesLabel.text = app?.releaseNotes
      appIconImageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
      priceButton.setTitle(app?.formattedPrice, for: .normal)
    }
  }
  
  let appIconImageView = UIImageView(cornerRadius: 24)
  let nameLabel = UILabel(text: "App Name", font: .boldSystemFont(ofSize: 24), numberOfLines: 2)
  let priceButton = UIButton(title: "$4.99")
  let whatsNewLabel = UILabel(text: "What's New", font: .boldSystemFont(ofSize: 20))
  let releaseNotesLabel = UILabel(text: "Release Notes", font: .systemFont(ofSize: 18), numberOfLines: 0)
  let separatorView = SeparatorView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    appIconImageView.backgroundColor = .white
    appIconImageView.constrainWidth(constant: 140)
    appIconImageView.constrainHeight(constant: 140)
    
    priceButton.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 0.937254902, alpha: 1)
    priceButton.constrainHeight(constant: 32)
    priceButton.layer.cornerRadius = 16
    priceButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    priceButton.setTitleColor(.white, for: .normal)
    priceButton.constrainWidth(constant: 80)
    
    separatorView.width = 0.3
    separatorView.color = .lightGray
    
    let stackView = VerticalStackView(arrangedSubviews: [
      UIStackView(arrangedSubviews: [
        appIconImageView,
        VerticalStackView(arrangedSubviews: [
          nameLabel,
          UIStackView(arrangedSubviews: [priceButton, UIView()]),
          UIView()
          ], spacing: 12)
        ], customSpacing: stackViewPadding),
      whatsNewLabel,
      releaseNotesLabel,
      separatorView,
      ], spacing: 16)
    addSubview(stackView)
    stackView.fillSuperview(padding: .init(top: stackViewPadding, left: stackViewPadding, bottom: stackViewPadding, right: stackViewPadding))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  fileprivate let stackViewPadding: CGFloat = 20
}
