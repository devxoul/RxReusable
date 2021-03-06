//
//  UITableView+RxReusable.swift
//  RxReusable
//
//  Created by Suyeol Jeon on 29/11/2016.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import UIKit

import RxCocoa

#if os(iOS)
extension UITableView {

  open override static func initialize() {
    guard self === UITableView.self else { return }
    self._rxreusable_swizzle(
      #selector(UITableView.init(frame:style:)),
      #selector(UITableView._rxreusable_init(frame:style:))
    )
  }

  func _rxreusable_init(frame: CGRect, style: UITableViewStyle) -> UITableView {
    let instance = self._rxreusable_init(frame: frame, style: style)
    _ = instance.rx.willDisplayCell
      .takeUntil(instance.rx.deallocated)
      .subscribe(onNext: { cell, indexPath in
        cell.traverseSubviews { view in
          (view as? UITableViewCell)?.rx.willDisplaySubject.onNext(indexPath)
        }
      })
    _ = instance.rx.didEndDisplayingCell
      .takeUntil(instance.rx.deallocated)
      .subscribe(onNext: { cell, indexPath in
        cell.traverseSubviews { view in
          (view as? UITableViewCell)?.rx.didEndDisplayingSubject.onNext(indexPath)
        }
      })
    return instance
  }

}
#endif
