//
//  AppsController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 06/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class AppsPageController: BaseListController {
    
    fileprivate let cellId   = "AppsGroupCell"
    fileprivate let headerId = "AppsPageHeader"
    fileprivate var groups   = [AppGroup]()
    fileprivate var headers  = [HeaderApp]()
    fileprivate let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = .gray
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        registerViews()
        fetchData()
    }
    
    fileprivate func setupViews() {
        collectionView.backgroundColor = .white
        view.addSubview(activityIndicator)
        activityIndicator.fillSuperview()
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
        Service.shared.fetchAppGroupByType(type: .newGames) { (appGroup, error) in
            dispatchGroup.leave()
            appGroup1 = appGroup
        }
        
        dispatchGroup.enter()
        Service.shared.fetchAppGroupByType(type: .topGrossing) { (appGroup, error) in
            dispatchGroup.leave()
            appGroup2 = appGroup
        }
        
        dispatchGroup.enter()
        Service.shared.fetchAppGroupByType(type: .topFree) { (appGroup, error) in
            dispatchGroup.leave()
            appGroup3 = appGroup
        }
        
        dispatchGroup.enter()
        Service.shared.fetchHeaders { [weak self] (headers, error) in
            dispatchGroup.leave()
            if let headers = headers {
                self?.headers = headers
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.activityIndicator.stopAnimating()
            
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
            cell.horizontalViewController.didSelectHandler = { [weak self] feedResult in
                let appDetailVC = AppDetailController(appId: feedResult.id)
                appDetailVC.navigationItem.title = feedResult.name
                self?.navigationController?.pushViewController(appDetailVC, animated: true)
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AppsPageHeader
        
        header.appHeaderHorizontalController.headers = headers
        header.appHeaderHorizontalController.collectionView.reloadData()
        
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
