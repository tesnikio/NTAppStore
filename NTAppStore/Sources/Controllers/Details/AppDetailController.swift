//
//  AppDetailController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 11/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class AppDetailController: BaseListController {
    
    fileprivate let appDetailId = "AppDetailCell"
    fileprivate let previewId = "PreviewCell"
    fileprivate var app: AppSearchResult?
    
    var appId: String! {
        didSet {
            let urlString = "https://itunes.apple.com/lookup?id=\(appId ?? "")"
            Service.shared.fetchGenericJSONData(urlString: urlString) { [weak self] (result: SearchResult?, error) in
                self?.app = result?.results.first
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        registerCells()
    }
    
    fileprivate func setupViews() {
        collectionView.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
    }
    
    fileprivate func registerCells() {
        collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: appDetailId)
        collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: previewId)
    }
}

//MARK: - UICollectionViewDataSource
extension AppDetailController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: appDetailId, for: indexPath) as! AppDetailCell
            cell.app = app
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previewId, for: indexPath) as! PreviewCell
            cell.screenshotsController.app = app
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension AppDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.item {
        case 0:
            let currentCell = AppDetailCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
            currentCell.app = app
            currentCell.layoutIfNeeded()
            
            let estimatedSize = currentCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
            
            return .init(width: view.frame.width, height: estimatedSize.height)
        case 1:
            return .init(width: view.frame.width, height: 500)
        default:
            return .zero
        }
        
        
    }
}
