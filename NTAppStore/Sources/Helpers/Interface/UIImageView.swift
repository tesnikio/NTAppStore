//
//  UIImageView.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 08/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

extension UIImageView {
  convenience init(cornerRadius: CGFloat) {
    self.init(image: nil)
    self.layer.cornerRadius = cornerRadius
    self.clipsToBounds = true
    self.contentMode = .scaleAspectFill
  }
}
