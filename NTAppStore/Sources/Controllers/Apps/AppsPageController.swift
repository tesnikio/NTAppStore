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
    fileprivate var groups = [AppGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        registerViews()
        fetchData()
    }
    
    fileprivate func setupViews() {
        collectionView.backgroundColor = .white
    }
    
    fileprivate func registerViews() {
        collectionView.register(AppsGroupCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(AppsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    fileprivate func fetchData() {
        
        var appGroup1: AppGroup?
        var appGroup2: AppGroup?
        var appGroup3: AppGroup?
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        Service.shared.fetchByType(type: .newGames) { (appGroup, error) in
            dispatchGroup.leave()
            appGroup1 = appGroup
        }
        
        dispatchGroup.enter()
        Service.shared.fetchByType(type: .topGrossing) { (appGroup, error) in
            dispatchGroup.leave()
            appGroup2 = appGroup
        }
        
        dispatchGroup.enter()
        Service.shared.fetchByType(type: .topFree) { (appGroup, error) in
            dispatchGroup.leave()
            appGroup3 = appGroup
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            if let appGroup = appGroup1 {
                self?.groups.append(appGroup)
            }
            
            if let appGroup = appGroup2 {
                self?.groups.append(appGroup)
            }
            
            if let appGroup = appGroup3 {
                self?.groups.append(appGroup)
            }
            
            self?.collectionView.reloadData()
        }
    }
}

//MARK: - UICollectionViewDataSource
extension AppsPageController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? AppsGroupCell {
            
            let appGroup = groups[indexPath.item]
            
            cell.sectionTitleLabel.text = appGroup.feed.title
            cell.horizontalViewController.appGroup = appGroup
            cell.horizontalViewController.collectionView.reloadData()
            return cell
        }
        
        return UICollectionViewCell()
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
    
    //enable header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 0)
    }
}
