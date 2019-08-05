//
//  AppsSearchController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 05/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class AppsSearchController: UICollectionViewController {
    
    fileprivate let cellId = "Cell"
    fileprivate var appResults = [Result]()
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        registerCells()
        fetchAppStoreApps()
    }
    
    fileprivate func setupViews() {
        collectionView.backgroundColor = .white
    }
    
    fileprivate func registerCells() {
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    fileprivate func fetchAppStoreApps() {
        Service.shared.fetchApps { [weak self] results, error in
            if let error = error {
                print("Failed to fetch apps: ", error)
                return
            }
            
            guard let self = self else { return }
            self.appResults = results
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

//MARK: - UICollectionViewDataSource
extension AppsSearchController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SearchResultCell {
            
            let appResult = appResults[indexPath.item]
            
            cell.nameLabel.text = appResult.trackName
            cell.categoryLabel.text = appResult.primaryGenreName
            cell.ratingsLabel.text = String(describing: appResult.userRatingCount != nil ? appResult.userRatingCount! : 0)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension AppsSearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 350)
    }
}


