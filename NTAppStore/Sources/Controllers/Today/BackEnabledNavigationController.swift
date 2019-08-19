//
//  BackEnabledNavigationController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 19/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class BackEnabledNavigationController: UINavigationController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.interactivePopGestureRecognizer?.delegate = self
    }
}

extension BackEnabledNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.viewControllers.count > 1
    }
}
