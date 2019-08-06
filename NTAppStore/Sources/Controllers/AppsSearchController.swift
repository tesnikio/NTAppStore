//
//  AppsSearchController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 05/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit
import SDWebImage

class AppsSearchController: UICollectionViewController {
    
    fileprivate let cellId = "Cell"
    fileprivate var appResults = [Result]()
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate var timer: Timer?
    
    fileprivate let placeholderSearchLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter app name above..."
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
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
        setupSearchBar()
    }
    
    fileprivate func setupViews() {
        collectionView.backgroundColor = .white
        collectionView.addSubview(placeholderSearchLabel)
        placeholderSearchLabel.fillSuperview(padding: .init(top: 250, left: 65, bottom: 0, right: 50))
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
extension AppsSearchController {
    
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

//MARK: - UICollectionViewDelegateFlowLayout
extension AppsSearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 350)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension AppsSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            Service.shared.fetchApps(searchTerm: searchText) { [weak self] results, error in
                if let error = error {
                    print("Failed to search apps: ", error)
                    return
                }
                guard let self = self else { return }
                self.appResults = results
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        })
    }
}



