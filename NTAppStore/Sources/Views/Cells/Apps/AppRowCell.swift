//
//  AppRowCell.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 07/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class AppRowCell: UICollectionViewCell {
  
  let appIconImageView = UIImageView(cornerRadius: 14)
  let nameLabel = UILabel(text: "App Name", font: .systemFont(ofSize: 16))
  let companyLabel = UILabel(text: "Company Name", font: .systemFont(ofSize: 14), textColor: .gray)
  let getButton = UIButton(title: "GET")
  
  fileprivate func setupViews() {
    appIconImageView.layer.borderColor = UIColor.gray.cgColor
    appIconImageView.layer.borderWidth = 0.3
    appIconImageView.constrainWidth(constant: 64)
    appIconImageView.constrainHeight(constant: 64)
    
    getButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
    getButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
    getButton.layer.cornerRadius = 16
    getButton.constrainWidth(constant: 80)
    getButton.constrainHeight(constant: 32)
    
    let stackView = UIStackView(arrangedSubviews: [appIconImageView, VerticalStackView(arrangedSubviews: [nameLabel, companyLabel], spacing: 4), getButton])
    stackView.spacing = 16
    stackView.alignment = .center
    addSubview(stackView)
    stackView.fillSuperview()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bindModel(_ model: FeedResult) {
    nameLabel.text = model.name
    companyLabel.text = model.artistName
    appIconImageView.sd_setImage(with: URL(string: model.artworkUrl100 ))
  }
}
