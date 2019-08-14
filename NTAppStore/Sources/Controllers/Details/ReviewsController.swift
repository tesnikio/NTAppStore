//
//  ReviewsController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 14/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class ReviewsController: HorizontalSnappingController {
    
    fileprivate let cellId = "ReviewRowCell"
    
    var reviews: Review? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        registerCells()
    }
    
    fileprivate func setupViews() {
        collectionView.backgroundColor = .white
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    fileprivate func registerCells() {
        collectionView.register(ReviewRowCell.self, forCellWithReuseIdentifier: cellId)
    }
}

//MARK: - UICollectionViewDataSource
extension ReviewsController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews?.feed.entry.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ReviewRowCell
        let entry = reviews?.feed.entry[indexPath.item]
        cell.titleLabel.text = entry?.title.label
        cell.authorLabel.text = entry?.author.name.label
        cell.reviewBodyLabel.text = entry?.content.label
        
        for (index, view) in cell.startStackView.arrangedSubviews.enumerated() {
            if let ratingInt = Int(entry!.rating.label) {
                view.alpha = index >= ratingInt ? 0 : 1
            }
        }
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ReviewsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 48, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
