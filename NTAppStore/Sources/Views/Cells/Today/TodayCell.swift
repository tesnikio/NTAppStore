//
//  TodayCell.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 16/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class TodayCell: BaseTodayCell {
  
  let imageView = UIImageView(image: #imageLiteral(resourceName: "garden.png"))
  let categoryLabel = UILabel(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
  let titleLabel = UILabel(text: "Utilizing Your Time", font: .boldSystemFont(ofSize: 28))
  let descriptionLabel = UILabel(text: "All the tools and apps you need to intelligently organize your life the right way.", font: .systemFont(ofSize: 16), numberOfLines: 3)
  
  override var todayItem: TodayItem! {
    didSet {
      imageView.image = UIImage(named: todayItem.imageName)
      categoryLabel.text = todayItem.category
      titleLabel.text = todayItem.title
      descriptionLabel.text = todayItem.description
      
      switch todayItem.backgroundColor {
      case .none:
        backgroundColor = .white
        backgroundView?.backgroundColor = .white
      case .gardenCellColor:
        backgroundColor = .white
        backgroundView?.backgroundColor = .white
      case .holidayCellColor:
        backgroundColor = #colorLiteral(red: 0.9844219089, green: 0.969078958, blue: 0.7214555144, alpha: 1)
        backgroundView?.backgroundColor = #colorLiteral(red: 0.9844219089, green: 0.969078958, blue: 0.7214555144, alpha: 1)
      }
    }
  }
  
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
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    
    let imageContainerView = UIView()
    imageContainerView.addSubview(imageView)
    imageView.centerInSuperview(size: .init(width: 220, height: 220))
    
    let stackView = VerticalStackView(arrangedSubviews: [
      categoryLabel,
      titleLabel,
      imageContainerView,
      descriptionLabel,
      ], spacing: 8)
    addSubview(stackView)
    stackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 24, bottom: 24, right: 24))
    self.topConstraint = stackView.topAnchor.constraint(equalTo: topAnchor, constant: 24)
    self.topConstraint.isActive = true
  }
  
  var topConstraint: NSLayoutConstraint!
}
