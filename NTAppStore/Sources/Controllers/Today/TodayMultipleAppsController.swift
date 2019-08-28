//
//  TodayMultipleAppsController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 19/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class TodayMultipleAppsController: BaseListController {
  
  init(mode: Mode) {
    self.mode = mode
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  let dismissButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "close_button"), for: .normal)
    button.tintColor = .darkGray
    button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    registerCells()
    closeButtonMode()
  }
  
  fileprivate func closeButtonMode() {
    if mode == .fullscreen {
      setupCloseButton()
    } else {
      collectionView.isScrollEnabled = false
    }
  }
  
  fileprivate func registerCells() {
    collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: multipleAppCellId)
  }
  
  fileprivate func setupViews() {
    collectionView.backgroundColor = .white
    navigationController?.isNavigationBarHidden = true
  }
  
  fileprivate func setupCloseButton() {
    view.addSubview(dismissButton)
    dismissButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: spacing, left: 0, bottom: 0, right: spacing), size: .init(width: buttonSize, height: buttonSize))
  }
  
  
  fileprivate let multipleAppCellId = "MultipleAppCell"
  fileprivate let spacing: CGFloat = 16
  fileprivate let mode: Mode
  fileprivate let fullScreenInset: CGFloat = 48
  fileprivate let numberOfItemsInSmallController = 4
  fileprivate let height: CGFloat = 68
  fileprivate let itemInset: CGFloat = 12
  fileprivate let buttonSize: CGFloat = 44
  var apps = [FeedResult]()
  override var prefersStatusBarHidden: Bool {
    return true
  }
}

//MARK: - Actions
extension TodayMultipleAppsController {
  @objc func handleDismiss() {
    dismiss(animated: true, completion: nil)
  }
}

//MARK: - UICollectionViewDataSource
extension TodayMultipleAppsController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch mode {
    case .fullscreen:
      return apps.count
    case .small:
      return numberOfItemsInSmallController
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: multipleAppCellId, for: indexPath) as? MultipleAppCell {
      cell.bind(to: apps[indexPath.item])
      return cell
    }
    return UICollectionViewCell()
  }
}

//MARK: - UICollectionViewDelegate
extension TodayMultipleAppsController {
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let appId = self.apps[indexPath.item].id
    let appDetailController = AppDetailController(appId: appId)
    navigationController?.pushViewController(appDetailController, animated: true)
  }
}


//MARK: - UICollectionViewDelegateFlowLayout
extension TodayMultipleAppsController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch mode {
    case .fullscreen:
      return .init(width: view.frame.width - fullScreenInset, height: height)
    case .small:
      return .init(width: view.frame.width, height: height)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return spacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    let cvInset = fullScreenInset / 2
    switch mode {
    case .fullscreen:
      return .init(top: itemInset, left: cvInset, bottom: itemInset, right: cvInset)
    case .small:
      return .zero
    }
  }
}
