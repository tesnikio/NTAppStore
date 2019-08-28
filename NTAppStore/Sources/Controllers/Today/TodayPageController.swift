//
//  TodayPageController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 16/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class TodayPageController: BaseListController {
  
  let activityIndicator: UIActivityIndicatorView = {
    let aiv = UIActivityIndicatorView(style: .whiteLarge)
    aiv.color = .darkGray
    aiv.startAnimating()
    aiv.hidesWhenStopped = true
    return aiv
  }()
  
  let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
  
  //MARK: - Setup UI
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
    view.addSubview(blurVisualEffectView)
    blurVisualEffectView.fillSuperview()
    blurVisualEffectView.alpha = 0
  }
  
  //MARK: - Private variables and constants
  var startingFrame: CGRect?
  var todayFullscreenController: TodayFullscreenController!
  var items: [TodayItem] = []
  var anchoredConstraint: AnchoredConstraints?
  var appFullscreenBeginOffset: CGFloat = 0
  
  fileprivate let minimumLineSpacing: CGFloat = 32
  public static let cellSize: CGFloat = 500
}

//MARK: - Functions
extension TodayPageController {
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
        TodayItem(category: "LIFE HACK", title: "Utilizing Your Time", imageName: "garden", description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .gardenCellColor, apps: [], cellType: .single),
        TodayItem(category: "Daily List", title: topFree.feed.title, imageName: "garden", description: "", backgroundColor: .none, apps: topFree.feed.results, cellType: .multiple),
        TodayItem(category: "Daily List", title: topGrossing.feed.title, imageName: "garden", description: "", backgroundColor: .none, apps: topGrossing.feed.results, cellType: .multiple),
        TodayItem(category: "HOLIDAYS", title: "Travel on a Budget", imageName: "holiday", description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: .holidayCellColor, apps: [], cellType: .single),
      ]
      
      self.collectionView.reloadData()
      self.activityIndicator.stopAnimating()
    }
  }
  
  fileprivate func showAppsListFullscreen(_ indexPath: IndexPath) {
    let listController = TodayMultipleAppsController(mode: .fullscreen)
    listController.apps = self.items[indexPath.item].apps
    present(BackEnabledNavigationController(rootViewController: listController), animated: true, completion: nil)
  }
  
  fileprivate func setupSingleTodayFullscreenController(_ indexPath: IndexPath) {
    let todayFullscreenController = TodayFullscreenController()
    let todayItem = items[indexPath.item]
    todayFullscreenController.todayItem = todayItem
    todayFullscreenController.dismissHandler = {
      self.handleTodayFullscreenDismissal()
    }
    self.todayFullscreenController = todayFullscreenController
    todayFullscreenController.view.layer.cornerRadius = 16
    
    let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
    gesture.delegate = self
    todayFullscreenController.view.addGestureRecognizer(gesture)
  }
  
  fileprivate func setupStartingCellFrame(_ indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) else { return }
    guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
    
    self.startingFrame = startingFrame
  }
  
  fileprivate func setupTodayFullscreenStartingPosition(_ indexPath: IndexPath) {
    self.collectionView.isUserInteractionEnabled = false
    guard let todayFullscreenView = todayFullscreenController.view else { return }
    
    view.addSubview(todayFullscreenView)
    addChild(todayFullscreenController)
    
    setupStartingCellFrame(indexPath)
    
    guard let startingFrame = self.startingFrame else { return }
    
    self.anchoredConstraint = todayFullscreenView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0), size: .init(width: startingFrame.width, height: startingFrame.height))
    
    self.view.layoutIfNeeded()
  }
  
  fileprivate func beginFullscreenAppAnimation() {
    UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
      self.blurVisualEffectView.alpha = 1
      
      self.anchoredConstraint?.top?.constant = 0
      self.anchoredConstraint?.leading?.constant = 0
      self.anchoredConstraint?.width?.constant = self.view.frame.width
      self.anchoredConstraint?.height?.constant = self.view.frame.height
      
      self.view.layoutIfNeeded()
      
      self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
      guard let cell = self.todayFullscreenController.tableView.cellForRow(at: [0, 0]) as? TodayHeaderCell else { return }
      cell.todayCell.topConstraint.constant = 48
      cell.layoutIfNeeded()
    }, completion: nil)
  }
  
  fileprivate func showSingleAppFullscreen(indexPath: IndexPath) {
    setupSingleTodayFullscreenController(indexPath)
    setupTodayFullscreenStartingPosition(indexPath)
    beginFullscreenAppAnimation()
  }
}

//MARK: - Actions
extension TodayPageController {
  @objc fileprivate func handleTodayFullscreenDismissal() {
    UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
      
      self.blurVisualEffectView.alpha = 0
      self.todayFullscreenController.view.transform = .identity
      
      self.todayFullscreenController.tableView.contentOffset = .zero
      
      guard let startingFrame = self.startingFrame else { return }
      self.anchoredConstraint?.top?.constant = startingFrame.origin.y
      self.anchoredConstraint?.leading?.constant = startingFrame.origin.x
      self.anchoredConstraint?.width?.constant = startingFrame.width
      self.anchoredConstraint?.height?.constant = startingFrame.height
      
      self.view.layoutIfNeeded()
      
      self.tabBarController?.tabBar.transform = .identity
      
      guard let cell = self.todayFullscreenController.tableView.cellForRow(at: [0, 0]) as? TodayHeaderCell else { return }
      self.todayFullscreenController.closeButton.alpha = 0
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
  
  @objc fileprivate func handleDrag(gesture: UIPanGestureRecognizer) {
    
    if gesture.state == .began {
      appFullscreenBeginOffset = todayFullscreenController.tableView.contentOffset.y
    }
    
    if todayFullscreenController.tableView.contentOffset.y > 0 {
      return
    }
    
    let translationY = gesture.translation(in: todayFullscreenController.view).y
    switch gesture.state {
    case .ended:
      if translationY > 0 {
        handleTodayFullscreenDismissal()
      }
    case .changed:
      let trueOffset = translationY - appFullscreenBeginOffset
      if translationY > 0 {
        var scale = 1 - trueOffset / 1000
        scale = min(1, scale)
        scale = max(0.5, scale)
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        self.todayFullscreenController.view.transform = transform
      }
    default:
      break
    }
  }
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
    (cell as? TodayMultipleAppCell)?.multipleAppsController.collectionView.isUserInteractionEnabled = false
    
    return cell
  }
}

//MARK: - UICollectionViewDelegate
extension TodayPageController {
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch items[indexPath.item].cellType {
    case .multiple:
      showAppsListFullscreen(indexPath)
    case .single:
      showSingleAppFullscreen(indexPath: indexPath)
    }
  }
}


//MARK: - UICollectionViewDelegateFlowLayout
extension TodayPageController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width - 2 * minimumLineSpacing, height: TodayPageController.cellSize)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return minimumLineSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: minimumLineSpacing, left: 0, bottom: minimumLineSpacing, right: 0)
  }
}

//MARK: - UIGestureRecognizerDelegate

extension TodayPageController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}


