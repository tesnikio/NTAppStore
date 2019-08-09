//
//  AppsController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 06/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class AppsPageController: BaseListController {
    
    fileprivate let cellId = "AppsGroupCell"
    fileprivate let headerId = "AppsPageHeader"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        registerViews()
    }
    
    fileprivate func setupViews() {
        collectionView.backgroundColor = .white
    }
    
    fileprivate func registerViews() {
        collectionView.register(AppsGroupCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(AppsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
}

//MARK: - UICollectionViewDataSource
extension AppsPageController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
        return header
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension AppsPageController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
}
