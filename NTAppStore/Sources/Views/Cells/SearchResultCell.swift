//
//  SearchResultCell.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 05/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "App Name"
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Photo & Video"
        return label
    }()
    
    let ratingsLabel: UILabel = {
        let label = UILabel()
        label.text = "9.26M"
        return label
    }()
    
    let getButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .yellow
        
        let labelsStackView = UIStackView(arrangedSubviews: [
                nameLabel, categoryLabel, ratingsLabel,
            ])
        labelsStackView.axis = .vertical
        
        let stackView = UIStackView(arrangedSubviews: [
                imageView, labelsStackView, getButton,
            ])
        stackView.spacing = 12
        stackView.alignment = .center
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: self.topAnchor),
                stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
