//
//  UIView+Utils.swift
//  RxReusable
//
//  Created by Suyeol Jeon on 13/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

extension UIView {
  func traverseSubviews(_ closure: (UIView) -> Void) {
    for subview in self.subviews {
      subview.traverseSubviews(closure)
    }
    closure(self)
  }
}
