//
//  UITableViewCell+RxReusable.swift
//  RxReusable
//
//  Created by Suyeol Jeon on 29/11/2016.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

#if os(iOS)
extension UITableViewCell: RxReusableCell {

  open override static func initialize() {
    guard self === UITableViewCell.self else { return }
    self._rxreusable_swizzle(
      #selector(UITableViewCell.prepareForReuse),
      #selector(UITableViewCell._rxreusable_prepareForReuse)
    )
  }

  func _rxreusable_prepareForReuse() {
    self._rxreusable_prepareForReuse()
    self.dispose()
  }

}
#endif
