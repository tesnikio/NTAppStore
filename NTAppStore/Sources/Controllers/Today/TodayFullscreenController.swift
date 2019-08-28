//
//  TodayFullscreenController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 16/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class TodayFullscreenController: UIViewController {
  
  let closeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
    button.tintColor = #colorLiteral(red: 0, green: 0.4779999852, blue: 1, alpha: 1)
    return button
  }()
  
  let getButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("GET", for: .normal)
    button.titleLabel?.font = .boldSystemFont(ofSize: 16)
    button.backgroundColor = .darkGray
    button.setTitleColor(.white, for: .normal)
    button.constrainWidth(constant: 80)
    button.constrainHeight(constant: 32)
    button.layer.cornerRadius = 16
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    delegating()
    setupFloatingControls()
  }
  
  fileprivate func setupFloatingControls() {
    floatingContainerView.layer.cornerRadius = spacing
    floatingContainerView.clipsToBounds = true
    view.addSubview(floatingContainerView)
    floatingContainerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: spacing, bottom: floatingContainerHeightOffset, right: spacing), size: .init(width: 0, height: 90))
    
    let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    floatingContainerView.addSubview(blurVisualEffectView)
    blurVisualEffectView.fillSuperview()
    
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    
    let imageView = UIImageView(cornerRadius: spacing)
    imageView.image = UIImage(named: todayItem?.imageName ?? "")
    imageView.constrainHeight(constant: 68)
    imageView.constrainWidth(constant: 68)
    
    let stackView = UIStackView(arrangedSubviews: [
      imageView,
      VerticalStackView(arrangedSubviews: [
        UILabel(text: "Life Hack", font: .boldSystemFont(ofSize: 18)),
        UILabel(text: "Utilizing Your Time", font: .systemFont(ofSize: 15)),
        ], spacing: 6),
      getButton,
      ], customSpacing: spacing)
    
    floatingContainerView.addSubview(stackView)
    stackView.fillSuperview(padding: .init(top: 0, left: spacing, bottom: 0, right: spacing))
    stackView.alignment = .center
  }
  
  fileprivate func setupViews() {
    view.clipsToBounds = true
    view.addSubview(tableView)
    tableView.fillSuperview()
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.allowsSelection = false
    tableView.contentInsetAdjustmentBehavior = .never
    let height = UIApplication.shared.statusBarFrame.height
    tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
    
    view.addSubview(closeButton)
    closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 40))
    closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
  }
  
  fileprivate func delegating() {
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  //MARK: - Local Instances
  let tableView = UITableView(frame: .zero, style: .plain)
  var todayItem: TodayItem?
  var dismissHandler: (() -> ())?
  fileprivate let floatingContainerView = UIView()
  fileprivate let cellTypes = [TodayFullscreenCellType.header, .description]
  fileprivate let floatingContainerHeightOffset: CGFloat = -90
  fileprivate let spacing: CGFloat = 16
}

//MARK: - UITableViewDataSource
extension TodayFullscreenController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cellTypes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch cellTypes[indexPath.item] {
    case .header:
      let cell = TodayHeaderCell()
      cell.todayCell.layer.cornerRadius = 0
      if let item = todayItem {
        cell.todayCell.todayItem = item
      }
      cell.clipsToBounds = true
      cell.todayCell.backgroundView = nil
      return cell
    case .description:
      let cell = TodayFullscreenDescriptionCell()
      return cell
    }
  }
}

//MARK: - UITableViewDelegate
extension TodayFullscreenController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch cellTypes[indexPath.item] {
    case .header:
      return TodayPageController.cellSize
    case .description:
      return UITableView.automaticDimension
    }
  }
}

//MARK: - Actions
extension TodayFullscreenController {
  @objc fileprivate func handleDismiss(button: UIButton) {
    button.isHidden = true
    dismissHandler?()
  }
  
  @objc fileprivate func handleTap() {
    UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: { [weak self] in
      self?.floatingContainerView.transform = .init(translationX: 0, y: self!.floatingContainerHeightOffset)
    })
  }
}

//MARK: - UIScrollViewDelegate
extension TodayFullscreenController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y < 0 {
      scrollView.isScrollEnabled = false
      scrollView.isScrollEnabled = true
    }
    
    let translationY = floatingContainerHeightOffset - UIApplication.shared.statusBarFrame.height
    let transform = scrollView.contentOffset.y > 100 ? CGAffineTransform(translationX: 0, y: translationY) : .identity
    
    UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: { [weak self] in
      
      self?.floatingContainerView.transform = transform
    })
  }
}

enum TodayFullscreenCellType {
  case header
  case description
}
