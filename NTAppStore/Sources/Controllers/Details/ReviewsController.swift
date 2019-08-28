//
//  ReviewsController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 14/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class ReviewsController: HorizontalSnappingController {
  
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
    collectionView.contentInset = .init(top: 0, left: minimumSpacing, bottom: 0, right: minimumSpacing)
  }
  
  fileprivate func registerCells() {
    collectionView.register(ReviewRowCell.self, forCellWithReuseIdentifier: cellId)
  }
  
  fileprivate func calculateRating(cell: ReviewRowCell, entry: Entry?) {
    for (index, view) in cell.startStackView.arrangedSubviews.enumerated() {
      if let ratingInt = Int(entry!.rating.label) {
        view.alpha = index >= ratingInt ? 0 : 1
      }
    }
  }
  
  fileprivate let cellId = "ReviewRowCell"
  fileprivate let minimumSpacing: CGFloat = 16
}

//MARK: - UICollectionViewDataSource
extension ReviewsController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return reviews?.feed.entry.count ?? 0
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ReviewRowCell {
      let entry = reviews?.feed.entry[indexPath.item]
      cell.bindModel(entry)
      calculateRating(cell: cell, entry: entry)
      return cell
    }
    return UICollectionViewCell()
  }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ReviewsController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width - 3 * minimumSpacing, height: view.frame.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return minimumSpacing
  }
}
