//
//  UICollectionViewCell+RxReusable.swift
//  RxReusable
//
//  Created by Suyeol Jeon on 29/11/2016.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

#if os(iOS)
extension UICollectionViewCell: RxReusableCell {

  open override static func initialize() {
    guard self === UICollectionViewCell.self else { return }
    self._rxreusable_swizzle(
      #selector(UICollectionViewCell.prepareForReuse),
      #selector(UICollectionViewCell._rxreusable_prepareForReuse)
    )
  }

  func _rxreusable_prepareForReuse() {
    self._rxreusable_prepareForReuse()
    self.dispose()
  }

}
#endif
