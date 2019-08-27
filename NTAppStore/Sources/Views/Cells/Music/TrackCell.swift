//
//  TrackCell.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 23/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class TrackCell: UICollectionViewCell {
    
    let imageView = UIImageView(cornerRadius: 16)
    let nameLabel = UILabel(text: "Track Name", font: .boldSystemFont(ofSize: 18))
    let subtitleLabel = UILabel(text: "Subtitle", font: .systemFont(ofSize: 16), numberOfLines: 2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        imageView.image = #imageLiteral(resourceName: "garden.png")
        imageView.constrainWidth(constant: 80)
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            VerticalStackView(arrangedSubviews: [
                nameLabel,
                subtitleLabel,
                ], spacing: 4),
            ], customSpacing: 16)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        stackView.alignment = .center
    }
    
    func bind(to model: AppSearchResult) {
        imageView.sd_setImage(with: URL(string: model.artworkUrl100))
        nameLabel.text = model.trackName
        subtitleLabel.text = model.artistName! + " • " + model.collectionName!
    }
}

