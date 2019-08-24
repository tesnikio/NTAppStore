//
//  AppDetailController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 11/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class AppDetailController: BaseListController {
    
    init(appId: String) {
        self.appId = appId
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        registerCells()
        fetchAppInfo()
    }
    
    fileprivate func setupViews() {
        collectionView.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
    }
    
    fileprivate func registerCells() {
        collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: appDetailId)
        collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: previewId)
        collectionView.register(ReviewsCell.self, forCellWithReuseIdentifier: reviewId)
    }
    
    fileprivate func fetchAppInfo() {
        let urlString = "https://itunes.apple.com/lookup?id=\(appId)"
        Service.shared.fetchGenericJSONData(urlString: urlString) { [weak self] (result: SearchResult?, error) in
            if let error = error {
                print("Failed to fetch data: ", error)
                return
            }
            self?.app = result?.results.first
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        let reviewsUrl = "https://itunes.apple.com/rss/customerreviews/page=1/id=\(appId)/sortby=mostrecent/json?l=en&cc=us"
        Service.shared.fetchGenericJSONData(urlString: reviewsUrl) { [weak self] (reviews: Review?, error) in
            if let error = error {
                print("Failed to fetch reviews: ", error)
                return
            }
            self?.reviews = reviews
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    fileprivate let appDetailId = "AppDetailCell"
    fileprivate let previewId   = "PreviewCell"
    fileprivate let reviewId    = "ReviewCell"
    fileprivate let appId: String
    fileprivate var app: AppSearchResult?
    fileprivate var reviews: Review?
    fileprivate let cellTypes = [CellType.appDetail, .preview, .review]
    fileprivate let bottomInset: CGFloat = 16
}

//MARK: - UICollectionViewDataSource
extension AppDetailController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellTypes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellType = cellTypes[indexPath.item]
        
        switch cellType {
        case .appDetail:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: appDetailId, for: indexPath) as! AppDetailCell
            cell.app = app
            return cell
        case .preview:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previewId, for: indexPath) as! PreviewCell
            cell.screenshotsController.app = app
            return cell
        case .review:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewId, for: indexPath) as! ReviewsCell
            cell.reviewsController.reviews = reviews
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension AppDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellType = cellTypes[indexPath.item]
        var height: CGFloat = 220
        
        switch cellType {
        case .appDetail:
            let currentCell = AppDetailCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
            currentCell.app = app
            currentCell.layoutIfNeeded()
            
            let estimatedSize = currentCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
            
            height = estimatedSize.height
        case .preview:
            height = 500
        case .review:
            height = 220
        }
        
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: bottomInset, right: 0)
    }
}

fileprivate enum CellType {
    case appDetail
    case preview
    case review
}
