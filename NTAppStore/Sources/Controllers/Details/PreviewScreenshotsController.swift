//
//  PreviewScreenshotsController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 13/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class PreviewScreenshotsController: HorizontalSnappingController {
    
    var app: AppSearchResult? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        registerCells()
    }
    
    fileprivate func registerCells() {
        collectionView.register(ScreenshotCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    fileprivate func setupViews() {
        collectionView.backgroundColor = .white
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    fileprivate let cellId = "ScreenshotCell"
    fileprivate let itemWidth: CGFloat = 250
}

//MARK: - UICollectionViewDataSource
extension PreviewScreenshotsController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return app?.screenshotUrls?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ScreenshotCell {
            let screenshotUrlString = app?.screenshotUrls?[indexPath.item]
            cell.screenshotImageView.sd_setImage(with: URL(string: screenshotUrlString ?? ""))
            return cell
        }
        return UICollectionViewCell()
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension PreviewScreenshotsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: itemWidth, height: view.frame.height)
    }
}
