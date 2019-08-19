//
//  TodayMultipleAppsController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 19/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class TodayMultipleAppsController: BaseListController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        registerCells()
    }
    
    fileprivate func registerCells() {
        collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: multipleAppCellId)
    }
    
    fileprivate func setupViews() {
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
    }
    
    fileprivate let multipleAppCellId = "MultipleAppCell"
    fileprivate let spacing: CGFloat = 16
    var results = [FeedResult]()
}

//MARK: - UICollectionViewDataSource
extension TodayMultipleAppsController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(4, results.count)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: multipleAppCellId, for: indexPath) as! MultipleAppCell
        cell.bind(to: results[indexPath.item])
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TodayMultipleAppsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = (view.frame.height - 3 * spacing) / 4
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
}
