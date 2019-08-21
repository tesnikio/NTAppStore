//
//  TodayPageController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 16/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class TodayPageController: BaseListController {
    
    var items: [TodayItem] = []
    
    let activityIndicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setupViews()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.superview?.setNeedsLayout()
    }
    
    fileprivate func registerCells() {
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
    }
    
    fileprivate func setupViews() {
        navigationController?.navigationBar.isHidden = true
        collectionView.backgroundColor = #colorLiteral(red: 0.9254021049, green: 0.9255538583, blue: 0.9253697395, alpha: 1)
        view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
    }
    
    @objc fileprivate func handleRemoveView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.todayFullscreenController.tableView.contentOffset = .zero
            
            guard let startingFrame = self.startingFrame else { return }
            self.topConstraint?.constant = startingFrame.origin.y
            self.leadingConstraint?.constant = startingFrame.origin.x
            self.widthConstraint?.constant = startingFrame.width
            self.heightConstraint?.constant = startingFrame.height
            
            self.view.layoutIfNeeded()
            
            self.tabBarController?.tabBar.transform = .identity
            
            guard let cell = self.todayFullscreenController.tableView.cellForRow(at: [0, 0]) as? TodayHeaderCell else { return }
            cell.todayCell.topConstraint.constant = 24
            cell.layoutIfNeeded()
            
        }, completion: { _ in
            self.todayFullscreenController.view.removeFromSuperview()
            self.todayFullscreenController.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
        })
    }
    
    @objc fileprivate func handleMultipleAppsTap(gesture: UITapGestureRecognizer) {
        
        let smallCollectionView = gesture.view
        var superview = smallCollectionView?.superview
        
        while superview != nil {
            if let cell = superview as? TodayMultipleAppCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                let fullFromCellController = TodayMultipleAppsController(mode: .fullscreen)
                let apps = self.items[indexPath.item].apps
                fullFromCellController.apps = apps
                let ncFullFromCellController = BackEnabledNavigationController(rootViewController: fullFromCellController)
                
                present(ncFullFromCellController, animated: true, completion: nil)
                return
            }
            superview = superview?.superview
        }
    }
    
    fileprivate func fetchData() {
        let dispatchGroup = DispatchGroup()
        var topFreeGroup: AppGroup?
        var topGrossingGroup: AppGroup?
        
        dispatchGroup.enter()
        Service.shared.fetchAppGroupByType(type: .topFree) { (appGroup, error) in
            dispatchGroup.leave()
            if let error = error {
                print("Failed to fetch top free apps: ", error)
                return
            }
            topFreeGroup = appGroup
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        dispatchGroup.enter()
        Service.shared.fetchAppGroupByType(type: .topGrossing) { (appGroup, error) in
            dispatchGroup.leave()
            if let error = error {
                print("Failed to fetch new games: ", error)
                return
            }
            topGrossingGroup = appGroup
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            
            guard let topFree = topFreeGroup else { return }
            guard let topGrossing = topGrossingGroup else { return }
            
            self.items = [
                TodayItem(category: "Daily List", title: topFree.feed.title, imageName: "garden", description: "", backgroundColor: .none, apps: topFree.feed.results, cellType: .multiple),
                TodayItem(category: "Daily List", title: topGrossing.feed.title, imageName: "garden", description: "", backgroundColor: .none, apps: topGrossing.feed.results, cellType: .multiple),
                TodayItem(category: "LIFE HACK", title: "Utilizing Your Time", imageName: "garden", description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .gardenCellColor, apps: [], cellType: .single),
                TodayItem(category: "HOLIDAYS", title: "Travel on a Budget", imageName: "holiday", description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: .holidayCellColor, apps: [], cellType: .single),
            ]
            
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    
    var startingFrame: CGRect?
    var todayFullscreenController: TodayFullscreenController!
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    static let cellSize: CGFloat = 500
}

//MARK: - UICollectionViewDataSource
extension TodayPageController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellType = items[indexPath.item].cellType
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.rawValue, for: indexPath) as! BaseTodayCell
        cell.todayItem = items[indexPath.item]
        
        (cell as? TodayMultipleAppCell)?.multipleAppsController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap)))
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension TodayPageController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if items[indexPath.item].cellType == .multiple {
            let listController = TodayMultipleAppsController(mode: .fullscreen)
            listController.apps = self.items[indexPath.item].apps
            present(BackEnabledNavigationController(rootViewController: listController), animated: true, completion: nil)
            return
        }
        
        let todayFullscreenController = TodayFullscreenController()
        let todayItem = items[indexPath.item]
        todayFullscreenController.todayItem = todayItem
        self.todayFullscreenController = todayFullscreenController
        self.collectionView.isUserInteractionEnabled = false
        guard let todayFullscreenView = todayFullscreenController.view else { return }
        todayFullscreenController.dismissHandler = {
            self.handleRemoveView()
        }
        
        todayFullscreenView.layer.cornerRadius = 16
        todayFullscreenView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(todayFullscreenView)
        addChild(todayFullscreenController)
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        self.startingFrame = startingFrame
        
        topConstraint = todayFullscreenController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
        leadingConstraint = todayFullscreenController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
        widthConstraint = todayFullscreenController.view.widthAnchor.constraint(equalToConstant: startingFrame.width)
        heightConstraint = todayFullscreenController.view.heightAnchor.constraint(equalToConstant: startingFrame.height)
        
        [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach { $0?.isActive = true }
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.topConstraint?.constant = 0
            self.leadingConstraint?.constant = 0
            self.widthConstraint?.constant = self.view.frame.width
            self.heightConstraint?.constant = self.view.frame.height
            
            self.view.layoutIfNeeded()
            
            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            
            guard let cell = self.todayFullscreenController.tableView.cellForRow(at: [0, 0]) as? TodayHeaderCell else { return }
            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()
            
        }, completion: nil)
    }
}


//MARK: - UICollectionViewDelegateFlowLayout
extension TodayPageController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: TodayPageController.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
}
