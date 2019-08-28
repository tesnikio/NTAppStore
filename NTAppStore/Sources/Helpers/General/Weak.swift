//
//  Weak.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 11/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import Foundation

final class Weak<T: AnyObject> {
  private weak var _value: T?
  var value: T? {
    return self._value
  }
  
  init(_ value: T) {
    self._value = value
  }
}
