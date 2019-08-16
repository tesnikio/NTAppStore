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
    }
}

//MARK: - UITableViewDataSource
extension TodayFullscreenController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == 0 {
            let cell = UITableViewCell()
            let todayCell = TodayCell()
            cell.addSubview(todayCell)
            todayCell.centerInSuperview(size: .init(width: 250, height: 250))
            return cell
        }
        
        let cell = TodayFullscreenDescriptionCell()
        return cell
    }
}


//MARK: - UITableViewDelegate
extension TodayFullscreenController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }
}
