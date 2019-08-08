//
//  UIButton.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 08/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(title: String) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
    }
}
