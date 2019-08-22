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
        let floatingContainerView = UIView()
        floatingContainerView.layer.cornerRadius = 16
        floatingContainerView.clipsToBounds = true
        view.addSubview(floatingContainerView)
        let bottomPadding = UIApplication.shared.statusBarFrame.height
        floatingContainerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: bottomPadding, right: 16), size: .init(width: 0, height: 90))
        
        let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        floatingContainerView.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        
        let imageView = UIImageView(cornerRadius: 16)
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
            ], customSpacing: 16)
        
        floatingContainerView.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
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
    
    let tableView = UITableView(frame: .zero, style: .plain)
    var dismissHandler: (() -> ())?
    var todayItem: TodayItem?
}

//MARK: - UITableViewDataSource
extension TodayFullscreenController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 0:
            let cell = TodayHeaderCell()
            cell.todayCell.layer.cornerRadius = 0
            if let item = todayItem {
                cell.todayCell.todayItem = item
            }
            cell.clipsToBounds = true
            cell.todayCell.backgroundView = nil
            return cell
        case 1:
            let cell = TodayFullscreenDescriptionCell()
            return cell
        default:
            return UITableViewCell()
        }
    }
}

//MARK: - UITableViewDelegate
extension TodayFullscreenController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return TodayPageController.cellSize
        default:
            return UITableView.automaticDimension
        }
    }
}

//MARK: - Actions
extension TodayFullscreenController {
    @objc func handleDismiss(button: UIButton) {
        button.isHidden = true
        dismissHandler?()
    }
}

//MARK: - UIScrollViewDelegate
extension TodayFullscreenController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
    }
}
