//
//  AppsHeaderHorizontalController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 09/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class AppsHeaderHorizontalController: BaseListController {
    
    fileprivate let cellId = "AppHeaderCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        registerCells()
    }
    
    fileprivate func setupViews() {
        collectionView.backgroundColor = .white
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
    
    fileprivate func registerCells() {
        collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: cellId)
    }
}

//MARK: - UICollectionViewDataSource
extension AppsHeaderHorizontalController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension AppsHeaderHorizontalController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 48, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 16, bottom: 0, right: 0)
    }
}
