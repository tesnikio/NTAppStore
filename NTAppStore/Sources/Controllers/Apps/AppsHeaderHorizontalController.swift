//
//  AppsHeaderHorizontalController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 09/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class AppsHeaderHorizontalController: HorizontalSnappingController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    registerCells()
  }
  
  fileprivate func setupViews() {
    collectionView.backgroundColor = .white
    collectionView.contentInset = .init(top: 0, left: cvInset, bottom: 0, right: cvInset)
    
    if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .horizontal
    }
  }
  
  fileprivate func registerCells() {
    collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: cellId)
  }
  
  fileprivate let cellId = "AppsHeaderCell"
  fileprivate let cvInset: CGFloat = 16
  var headers = [HeaderApp]()
}

//MARK: - UICollectionViewDataSource
extension AppsHeaderHorizontalController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return headers.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? AppsHeaderCell {
      let header = headers[indexPath.item]
      cell.bindModel(header)
      return cell
    }
    return UICollectionViewCell()
  }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension AppsHeaderHorizontalController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width - 3 * cvInset, height: view.frame.height)
  }
}
