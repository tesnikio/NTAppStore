//
//  TodayItem.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 17/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import Foundation

enum BackgroundColor {
    case gardenCellColor
    case holidayCellColor
}

struct TodayItem {
    let category: String
    let title: String
    let imageName: String
    let description: String
    let backgroundColor: BackgroundColor
}
