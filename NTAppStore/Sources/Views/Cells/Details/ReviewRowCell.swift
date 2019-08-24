//
//  ReviewRowCell.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 14/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class ReviewRowCell: UICollectionViewCell {
    
    let titleLabel = UILabel(text: "Review Title", font: .boldSystemFont(ofSize: 18))
    let authorLabel = UILabel(text: "Author", font: .systemFont(ofSize: 16))
    let reviewBodyLabel = UILabel(text: "Review text", font: .systemFont(ofSize: 16), numberOfLines: 5)
    let startStackView: UIStackView = {
        var arrangedSubviews = [UIView]()
        (0..<5).forEach { _ in
            let imageView = UIImageView(image: #imageLiteral(resourceName: "star.jpeg"))
            imageView.constrainWidth(constant: 20)
            imageView.constrainHeight(constant: 20)
            arrangedSubviews.append(imageView)
        }
        
        arrangedSubviews.append(UIView())
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        backgroundColor = #colorLiteral(red: 0.9420462251, green: 0.9367366433, blue: 0.9714002013, alpha: 1)
        layer.cornerRadius = 16
        clipsToBounds = true
        authorLabel.textColor = .gray
        authorLabel.textAlignment = .right
        titleLabel.setContentCompressionResistancePriority(.init(0), for: .horizontal)
        
        
        let stackView = VerticalStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [
                titleLabel,
                authorLabel,
                ], customSpacing: 8),
            startStackView,
            reviewBodyLabel,
            ], spacing: 12)
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
    }
    
    func bindModel(_ model: Entry?) {
        titleLabel.text = model?.title.label
        authorLabel.text = model?.author.name.label
        reviewBodyLabel.text = model?.content.label
    }
}
