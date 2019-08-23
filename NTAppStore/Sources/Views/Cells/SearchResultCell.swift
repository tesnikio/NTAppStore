//
//  SearchResultCell.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 05/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
    
    var appResult: AppSearchResult! {
        didSet {
            nameLabel.text = appResult.trackName
            categoryLabel.text = appResult.primaryGenreName
            ratingsLabel.text = "Rating: " + String(describing: appResult.averageUserRating != nil ? appResult.averageUserRating! : 0)
            appIconImageView.sd_setImage(with: URL(string: appResult.artworkUrl100))
            screenshot1ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls![0]))
            
            if appResult.screenshotUrls!.count > 1 {
                screenshot2ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls![1]))
            }
            
            if appResult.screenshotUrls!.count > 2 {
                screenshot3ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls![2]))
            }
        }
    }
    
    let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        imageView.layer.cornerRadius = 14
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 0.3
        return imageView
    }()
    
    let nameLabel = UILabel()
    let categoryLabel = UILabel(text: "Category", font: .systemFont(ofSize: 14), textColor: .gray)
    let ratingsLabel = UILabel(text: "Rating", font: .systemFont(ofSize: 14), textColor: .gray)

    let getButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("GET", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    lazy var screenshot1ImageView = self.createScreenshotImageView()
    lazy var screenshot2ImageView = self.createScreenshotImageView()
    lazy var screenshot3ImageView = self.createScreenshotImageView()
    
    func createScreenshotImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 0.4
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    fileprivate func setupViews() {
        let infoTopStackView = UIStackView(arrangedSubviews: [
            appIconImageView,
            VerticalStackView(arrangedSubviews: [
                nameLabel, categoryLabel, ratingsLabel,
                ]),
            getButton,
            ])
        infoTopStackView.spacing = 12
        infoTopStackView.alignment = .center
        
        let screenshotsStackView = UIStackView(arrangedSubviews: [
            screenshot1ImageView, screenshot2ImageView, screenshot3ImageView,
            ])
        screenshotsStackView.spacing = 12
        screenshotsStackView.distribution = .fillEqually
        
        let overallStackView = VerticalStackView(arrangedSubviews: [
            infoTopStackView, screenshotsStackView,
            ], spacing: 16)
        
        addSubview(overallStackView)
        overallStackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}
