//
//  HorizontalSnappingController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 11/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class HorizontalSnappingController: UICollectionViewController {
  init() {
    let layout = SnappingLayout()
    layout.scrollDirection = .horizontal
    super.init(collectionViewLayout: layout)
    collectionView.decelerationRate = .fast
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

