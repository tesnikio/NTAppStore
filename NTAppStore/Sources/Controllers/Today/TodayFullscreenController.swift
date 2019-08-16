//
//  TodayFullscreenController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 16/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class TodayFullscreenController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    fileprivate func setupViews() {
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
}

//MARK: - UITableViewDataSource
extension TodayFullscreenController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 0:
            return TodayHeaderCell()
        case 1:
            return TodayFullscreenDescriptionCell()
        default:
            return UITableViewCell()
        }
    }
}


//MARK: - UITableViewDelegate
extension TodayFullscreenController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 450
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
}
