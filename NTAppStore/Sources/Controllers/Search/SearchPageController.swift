//
//  SearchPageController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 05/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit
import SDWebImage

class SearchPageController: BaseListController {
    
    fileprivate let cellId = "SearchResultCell"
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate let itemHeight: CGFloat = 350
    fileprivate var timer: Timer?
    fileprivate var appResults = [AppSearchResult]()
    fileprivate let placeholderSearchLabel = UILabel(text: "No search results",
                                                     font: .systemFont(ofSize: 20, weight: .medium),
                                                     textColor: .lightGray,
                                                     textAlignment: .center)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        registerCells()
        setupSearchBar()
    }
    
    fileprivate func setupViews() {
        collectionView.backgroundColor = .white
        collectionView.addSubview(placeholderSearchLabel)
        placeholderSearchLabel.centerXInSuperview()
        placeholderSearchLabel.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 200).isActive = true
        searchController.searchBar.placeholder = "Enter the app name"
    }
    
    fileprivate func registerCells() {
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    fileprivate func setupSearchBar() {
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
}

//MARK: - UICollectionViewDataSource
extension SearchPageController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        placeholderSearchLabel.isHidden = appResults.count != 0
        return appResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SearchResultCell {
            cell.appResult = appResults[indexPath.item]
            return cell
        }
        
        return UICollectionViewCell()
    }
}

//MARK: - UICollectionViewDelegate
extension SearchPageController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appResult = appResults[indexPath.item]
        let appDetailController = AppDetailController(appId: String(appResult.trackId))
        navigationController?.pushViewController(appDetailController, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension SearchPageController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: itemHeight)
    }
}

//MARK: - UISearchBarDelegate
extension SearchPageController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            Service.shared.fetchAppsSearch(searchTerm: searchText) { [weak self] searchData, error in
                if let error = error {
                    print("Failed to search apps: ", error)
                    return
                }
                guard let self = self else { return }
                guard let searchData = searchData else { return }
                self.appResults = searchData.results
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        })
    }
}

//MARK: - UIScrollViewDelegate
extension SearchPageController {
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
}



