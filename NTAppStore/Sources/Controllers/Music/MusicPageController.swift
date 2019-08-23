//
//  MusicPageController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 23/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class MusicPageController: BaseListController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        registerCells()
        fetchData()
    }
    
    fileprivate func setupViews() {
        collectionView.backgroundColor = .white
    }
    
    fileprivate func registerCells() {
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: trackCellId)
        collectionView.register(TracksLoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: tracksLoadingFooterId)
    }
    
    fileprivate func fetchData() {
        let stringUrl = "https://itunes.apple.com/search?term=\(searchTerm)&offset=0&limit=20"
        Service.shared.fetchGenericJSONData(urlString: stringUrl) { [weak self] (searchResult: SearchResult?, error) in
            if let error = error {
                print("Failed to fetch music: ", error)
                return
            }
           
            guard let results = searchResult?.results else { return }
            
            self?.results = results
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    fileprivate let trackCellId = "TrackCell"
    fileprivate let tracksLoadingFooterId = "TracksLoadingFooter"
    fileprivate let searchTerm = "theweeknd"
    fileprivate var results = [AppSearchResult]()
    fileprivate var isPaginating = false
    fileprivate var isDonePaginating = false
}

//MARK: - UICollectionViewDataSource
extension MusicPageController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: trackCellId, for: indexPath) as! TrackCell
        let result = results[indexPath.item]
        cell.imageView.sd_setImage(with: URL(string: result.artworkUrl100))
        cell.nameLabel.text = result.trackName
        cell.subtitleLabel.text = result.artistName! + " • " + result.collectionName!
        
        if indexPath.item == results.count - 1 && !isPaginating {
            isPaginating = true
            let stringUrl = "https://itunes.apple.com/search?term=\(searchTerm)&offset=\(results.count)&limit=20"
            Service.shared.fetchGenericJSONData(urlString: stringUrl) { [weak self] (searchResult: SearchResult?, error) in
                if let error = error {
                    print("Failed to fetch music: ", error)
                    return
                }
                
                if searchResult?.results.count == 0 {
                    self?.isDonePaginating = true
                }
                
                sleep(2)
                
                guard let results = searchResult?.results else { return }
                
                self?.results += results
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
                
                self?.isPaginating = false
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: tracksLoadingFooterId, for: indexPath)
        return footer
    }
}

//MARK: - UICollectionViewDelegate
extension MusicPageController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = isDonePaginating ? 0 : 100
        return .init(width: view.frame.width, height: height)
    }
}


//MARK: - UICollectionViewDelegateFlowLayout
extension MusicPageController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
}
